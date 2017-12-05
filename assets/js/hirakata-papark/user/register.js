'use strict';

var Vue = require('vue');
var VTooltip = require('v-tooltip');
var superagent = require('superagent');

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
  new Vue({
    el: '#user-register',
    data: {
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
      clearErrors: function () {
        ['idErrors', 'passwordErrors', 'nameErrors'].forEach(function (elem) {
          this[elem] = [];
        }.bind(this));
      },
      isFormEmpty: function () {
        return this.id === '' && this.name === '' && this.password === '';
      },
      send: function () {
        if ( !this.isFormEmpty() ) {
          superagent
            .post(this.url)
            .query({
              id: this.id,
              password: this.password,
              name: this.name,
            })
            .end(function (err, res) {
              var json = JSON.parse(res.text);
              this.clearErrors();
              if (!json.is_success) {
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
