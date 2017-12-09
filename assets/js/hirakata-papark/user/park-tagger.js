'use strict';

var Vue = require('vue');
var VTooltip = require('v-tooltip');
var superagent = require('superagent');

/*
 * args: {
 *   tagName: Str,
 *   url: Str,
 * }
 */

module.exports = function (args) {
  Vue.use(VTooltip);
  new Vue({
    el: '#v-park-tagger',
    data: {
      url: args.url,
      tagName: '',
      tagNameErrors: [],
      tagNameConditions: args.tagNameConditions,
    },
    methods: {
      clearErrors: function () { this.tagNameErrors = []; },
      isFormEmpty: function () { return this.tagName === ''; },
      send: function () {
        if ( !this.isFormEmpty() ) {
          superagent
            .post(this.url)
            .query({tag_name: this.tagName})
            .end(function (err, res) {
              var json = JSON.parse(res.text);
              this.clearErrors();
              if (json.is_success) {
                location.assign(json.redirect_to);
              } else {
                Object.keys(json.errors).forEach(function (key) {
                  var error = json.errors[key];
                  this.tagNameErrors = error.messages;
                }.bind(this));
              }
            }.bind(this));
        }
      },
    },
  });
};
