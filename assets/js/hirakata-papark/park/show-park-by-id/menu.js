'use strict';

var Vue = require('vue');
var superagent = require('superagent');

var Z_INDEX = 500;
var MENU_WIDTH = 220;
var MENU_TOP_MARGIN = 5;

module.exports = new Vue({
  el: '#v-park-menu',
  data: {
    isOpened: false,
    menuButtonClassObject: {
      clicked: false,
    },
    menuStyleObject: {
      top: '0px',
      left: '0px',
      right: '0px',
    },
  },
  mounted: function () {
    this.menuStyleObject.width = MENU_WIDTH + 'px';
    this.resize();
    window.addEventListener('click', function (eve) {
      eve.stopPropagation();
      this.closeMenu();
    }.bind(this));
    window.addEventListener('resize', function (eve) {
      this.resize();
    }.bind(this));
  },
  methods: {
    clickIcon: function (eve) {
      eve.stopPropagation();
      this.resize();
      if (this.isOpened) {
        this.closeMenu();
      } else {
        this.openMenu();
      }
    },
    resize: function () {
      var rect = this.$el.getElementsByTagName('i')[0].getBoundingClientRect();
      this.menuStyleObject.left = (rect.left - MENU_WIDTH + rect.width) + 'px';
      this.menuStyleObject.top = (rect.top + rect.height + MENU_TOP_MARGIN) + 'px';
    },
    openMenu: function () {
      this.isOpened = true;
      this.menuButtonClassObject.clicked = true;
      this.menuStyleObject.display = 'block';
      this.menuStyleObject['z-index'] = Z_INDEX;
    },
    closeMenu: function () {
      this.isOpened = false;
      this.menuButtonClassObject.clicked = false;
      this.menuStyleObject.display = 'none';
      this.menuStyleObject['z-index'] = 0;
    },
  },
});
