'use strict';

var Vue = require('vue');
var VTooltip = require('v-tooltip');
var superagent = require('superagent');
var Util = require('../util');

/*
 * args: {
 *   url: Str,
 *   titleConditions: Str,
 *   imageFileConditions: Str,
 * }
 */

module.exports = function (args) {
  Vue.use(VTooltip);
  new Vue({
    el: '#v-park-image-poster',
    data: {
      url: args.url,
      imageFile: undefined,
      imageFilePath: '',
      imageFileErrors: [],
      imageFileConditions: args.imageFileConditions,
      title: '',
      titleErrors: [],
      titleConditions: args.titleConditions,
      isImageFileUploading: false,
    },
    methods: {
      clearErrors: function () {
        ['titleErrors', 'imageFileErrors'].forEach(function (elem) {
          this[elem] = [];
        }.bind(this));
      },
      isFormEmpty: function () {
        return this.title === '' && this.imageFile === undefined;
      },
      selectImage: function (eve) {
        eve.preventDefault();
        this.imageFile = eve.target.files[0];
        this.imageFilePath = this.imageFile.name;
      },
      send: function () {
        if ( !this.isFormEmpty() ) {
          this.isImageFileUploading = true;
          superagent
            .post(this.url)
            .set('title', this.title)
            .attach('image_file', this.imageFile)
            .end(function (err, res) {
              var json = JSON.parse(res.text);
              this.clearErrors();
              this.isImageFileUploading = false;
              if (json.is_success) {
                location.assign(json.redirect_to);
              } else {
                Object.keys(json.errors).forEach(function (key) {
                  var error = json.errors[key];
                  this[Util.toCamelCase(error.name) + 'Errors'] = error.messages;
                }.bind(this));
              }
            }.bind(this));
        }
      },
    },
  });
};
