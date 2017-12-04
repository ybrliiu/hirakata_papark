'use strict';

var Vue = require('vue');
var searchFormMixin = require('./search-form-mixin');
var checkBoxesFormMixin = require('./check-boxes-form-mixin');

module.exports = new Vue({
  mixins: [searchFormMixin, checkBoxesFormMixin],
  el: '#search-equipment',
  methods: {
    query: function () { return {equipments: this.items} },
  },
});

