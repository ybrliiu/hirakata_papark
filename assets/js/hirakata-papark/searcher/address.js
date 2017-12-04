'use strict';

var Vue = require('vue');
var searchFormMixin = require('./search-form-mixin');

module.exports = new Vue({
  mixins: [searchFormMixin],
  el: '#search-address',
  data: { parkAddress: '' },
  methods: {
    isFormEmpty: function () { return this.parkAddress === '' },
    query: function () { return {park_address: this.parkAddress} },
  },
});

