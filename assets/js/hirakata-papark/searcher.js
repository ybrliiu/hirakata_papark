'use strict';

var Vue = require('vue');
var searchForm = require('./components/search-form');

module.exports = new Vue({
  el: '.v-search-form',
  components: searchForm(),
});

