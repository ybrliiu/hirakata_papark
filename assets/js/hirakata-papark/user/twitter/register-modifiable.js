'use strict';

var Vue = require('vue');
var VTooltip = require('v-tooltip');
var superagent = require('superagent');

/*
 * args :{
 *   url: Str,
 *   id: Str,
 *   name: Str,
 *   idConditions: Str,
 *   nameConditions: Str,
 * }
 */

module.exports = function (args) {

  Vue.use(VTooltip);

  new Vue({
    el: '#v-user-twitter-register-modifiable',
    data: {
      id: args.id,
      name: args.name,
      idErrors: [],
      nameErrors: [],
      url: args.url,
      idConditions: args.idConditions,
      nameConditions: args.nameConditions,
    },
    methods: {
      clearErrors: function () {
        ['idErrors', 'nameErrors'].forEach(function (elem) {
          this[elem] = [];
        }.bind(this));
      },
      isFormEmpty: function () {
        return this.id === '' && this.name === '';
      },
      send: function () {
        if ( !this.isFormEmpty() ) {
          superagent
            .post(this.url)
            .query({
              id: this.id,
              name: this.name,
            })
            .end(function (err, res) {
              var json = JSON.parse(res.text);
              this.clearErrors();
              if (json.is_success) {
                location.assign(json.redirect_to);
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
