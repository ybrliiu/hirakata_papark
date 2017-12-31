'use strict';

var Vue = require('vue');
var VTooltip = require('v-tooltip');
var superagent = require('superagent');
var responceFetchable = require('../../mixin/responceFetchable');

/*
 * args :{
 *   id: Str,
 *   name: Str,
 *   idConditions: Str,
 *   nameConditions: Str,
 *   url: Str,
 * }
 */

module.exports = function (args) {

  Vue.use(VTooltip);

  return new Vue({
    el: '#v-user-twitter-register-modifiable',
    mixins: [responceFetchable],
    data: {
      sendItems: ['id', 'name'],
      id: args.id,
      name: args.name,
      idErrors: [],
      nameErrors: [],
      idConditions: args.idConditions,
      nameConditions: args.nameConditions,
      url: args.url,
    },
    methods: {
      onFetchResponce: function () {
        superagent
          .post(this.url)
          .type('form')
          .send({id: this.id, name: this.name})
          .end(this.onFetchResponceComplete);
      },
    },
  });
};
