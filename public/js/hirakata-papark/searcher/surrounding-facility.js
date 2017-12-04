'use strict';

var Vue = require('vue');
var searchFormMixin = require('./search-form-mixin');
var checkBoxesFormMixin = require('./check-boxes-form-mixin');

module.exports = new Vue({
  mixins: [searchFormMixin, checkBoxesFormMixin],
  el: '#search-surrounding-facility',
  methods: {
    query: function () { return {surrounding_facilities: this.items} },
  },
});

