'use strict';

var Vue = require('vue');
var VTooltip = require('v-tooltip');
var superagent = require('superagent');
var responceFetchable = require('../mixin/responceFetchable');

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
    mixins: [responceFetchable],
    el: '#v-park-image-poster',
    data: {
      url: args.url,
      sendItems: ['title', 'imageFile', 'filenameExtension'],
      imageFile: undefined,
      imageFilePath: '',
      imageFileErrors: [],
      imageFileConditions: args.imageFileConditions,
      filenameExtensionErrors: [],
      title: '',
      titleErrors: [],
      titleConditions: args.titleConditions,
    },
    methods: {
      isFormEmpty: function () {
        return this.title === '' && this.imageFile === undefined;
      },
      selectImage: function (eve) {
        eve.preventDefault();
        this.imageFile = eve.target.files[0];
        this.imageFilePath = this.imageFile.name;
      },
      onFetchResponce: function () {
        superagent
          .post(this.url)
          .field('title', this.title)
          .attach('image_file', this.imageFile)
          .end(this.onFetchResponceComplete);
      },
    },
  });
};
