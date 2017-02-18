'use strict';

(function () {

  hirakataPapark.namespace('menu');
  hirakataPapark.menu = {};
  var PACKAGE = hirakataPapark.menu;

  PACKAGE.sideMenu = new Vue({
    el: '#side-menu',
    data: {
      isShow: false,
    },
    methods: {
      show: function () { this.isShow = true; },
      close: function () { this.isShow = false; },
      stopClose: function (eve) { eve.stopPropagation(); },
    },
    created: function () { window.addEventListener('click', this.close.bind(this)); },
    destroyed: function () { window.removeEventListener('click', this.close.bind(this)); },
  });

  PACKAGE.showMenuButton = new Vue({
    el: '#show-menu-button',
    methods: {
      showSideMenu: function (eve) {
        eve.stopPropagation();
        PACKAGE.sideMenu.show();
      },
    },
  });

}());

