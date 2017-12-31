'use strict';

var Vue = require('vue');
var superagent = require('superagent');
var responceFetchable = require('../mixin/responceFetchable');

/*
 * args :{
 *   url: Str,
 *   moveTo: Str,
 * }
 */

module.exports = function (args) {

  require('./sns-session');

  return new Vue({
    el: '#v-user-session',
    mixins: [responceFetchable],
    data: {
      sendItems: ['id', 'password'],
      id: '',
      password: '',
      idErrors: [],
      passwordErrors: [],
      url: args.url,
      moveTo: args.moveTo,
    },
    methods: {
      onFetchResponceSuccess: function (json) {
        location.assign(document.referrer === '' ? '../mypage' : document.referrer);
      },
      onFetchResponce: function () {
        superagent
          .post(this.url)
          .type('form')
          .send({id: this.id, password: this.password})
          .end(this.onFetchResponceComplete);
      },
    },
  });

};

