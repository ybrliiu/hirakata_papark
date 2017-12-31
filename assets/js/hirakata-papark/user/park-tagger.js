'use strict';

var Vue = require('vue');
var VTooltip = require('v-tooltip');
var superagent = require('superagent');
var responceFetchable = require('../mixin/responceFetchable');

/*
 * args: {
 *   tagName: Str,
 *   url: Str,
 * }
 */

module.exports = function (args) {
  Vue.use(VTooltip);
  return new Vue({
    el: '#v-park-tagger',
    mixins: [responceFetchable],
    data: {
      url: args.url,
      sendItems: ['tagName'],
      tagName: '',
      tagNameErrors: [],
      tagNameConditions: args.tagNameConditions,
    },
    methods: {
      onFetchResponce: function () {
        superagent
          .post(this.url)
          .type('form')
          .send({tag_name: this.tagName})
          .end(this.onFetchResponceComplete);
      },
    },
  });
};
