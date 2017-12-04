'use strict';

var Vue = require('vue');

new Vue({
  el: '#side-menu',
  data: {
    isShow: false,
  },
  methods: {
    show: function () { this.isShow = true; },
    close: function () { this.isShow = false; },
    stopClose: function (eve) { eve.stopPropagation(); },
    showSideMenu: function (eve) {
      eve.stopPropagation();
      this.show();
    },
  },
  created: function () { window.addEventListener('click', this.close.bind(this)); },
  destroyed: function () { window.removeEventListener('click', this.close.bind(this)); },
});

