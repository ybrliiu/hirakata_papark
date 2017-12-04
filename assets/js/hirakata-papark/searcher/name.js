'use strict';

var Vue = require('vue');
var searchFormMixin = require('./search-form-mixin');

module.exports = new Vue({
  mixins: [searchFormMixin],
  el: '#search-name',
  data: { parkName: '' },
  methods: {
    isFormEmpty: function () { return this.parkName === '' },
    query: function () { return {park_name: this.parkName} },
  },
});

