'use strict';

var Vue = require('vue');
var VTooltip = require('v-tooltip');
var superagent = require('superagent');

/*
 * args :{
 *   url: Str,
 *   moveTo: Str,
 * }
 */

module.exports = function (args) {
  Vue.use(VTooltip);
  new Vue({
    el: '#user-session',
    data: {
      url: args.url,
      moveTo: args.moveTo,
      id: '',
      password: '',
      idErrors: [],
      passwordErrors: [],
    },
    methods: {
      clearErrors: function () {
        ['idErrors', 'passwordErrors'].forEach(function (elem) {
          this[elem] = [];
        }.bind(this));
      },
      isFormEmpty: function () {
        return this.id === '' && this.password === '';
      },
      send: function () {
        if ( !this.isFormEmpty() ) {
          superagent
            .post(this.url)
            .query({
              id: this.id,
              password: this.password,
            })
            .end(function (err, res) {
              var json = JSON.parse(res.text);
              this.clearErrors();
              if (json.is_success) {
                location.assign(document.referrer === '' ? '../mypage' : document.referrer);
              } else {
                Object.keys(json.errors).forEach(function (key) {
                  var error = json.errors[key];
                  this[error.name + 'Errors'] = error.messages;
                }.bind(this));
              }
            }.bind(this));
        }
      },
    },
  });
};

