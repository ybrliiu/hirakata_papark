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
  mounted: function () {
    // iOSでもclickイベントを動作させられるように, bodyにはイベントを登録せず子要素に登録
    [window, document.getElementsByClassName('click-wrapper')[0]].forEach(function (elem) {
      elem.addEventListener('click', this.close.bind(this));
    }.bind(this));
  },
});

