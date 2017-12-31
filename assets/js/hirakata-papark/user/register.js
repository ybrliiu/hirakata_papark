'use strict';

var Vue = require('vue');
var VTooltip = require('v-tooltip');
var superagent = require('superagent');
var responceFetchable = require('../mixin/responceFetchable');

/*
 * args :{
 *   url: Str,
 *   idConditions: Str,
 *   passWordConditions: Str,
 *   nameConditions: Str,
 * }
 */

module.exports = function (args) {

  Vue.use(VTooltip);

  require('./sns-session');

  return new Vue({
    el: '#v-user-register',
    mixins: [responceFetchable],
    data: {
      sendItems: ['id', 'password', 'name'],
      id: '',
      password: '',
      name: '',
      idErrors: [],
      passwordErrors: [],
      nameErrors: [],
      url: args.url,
      idConditions: args.idConditions,
      passWordConditions: args.passWordConditions,
      nameConditions: args.nameConditions,
    },
    methods: {
      onFetchResponceSuccess: function (json) {
        location.assign(document.referrer === '' ? '../mypage' : document.referrer);
      },
      onFetchResponce: function () {
        superagent
          .post(this.url)
          .type('form')
          .send({
            id: this.id,
            password: this.password,
            name: this.name,
          })
          .end(this.onFetchResponceComplete);
      },
    },
  });

};
