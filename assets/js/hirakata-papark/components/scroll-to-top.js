'use strict';

var MOVE_Y = -50;

module.exports = {
  data: function () {
    return {
      isShow: false,
      windowHeight: window.innerHeight,
    };
  },
  created: function () {
    window.addEventListener('scroll', this.onScrollCallback.bind(this));
  },
  methods: {
    ensureCanShow: function () {
      return window.pageYOffset > this.windowHeight && !this.isShow;
    },
    ensureCanHide: function () {
      return window.pageYOffset < this.windowHeight && this.isShow;
    },
    onScrollCallback: function (e) {
      if ( this.ensureCanShow() ) {
        this.isShow = true;
      }
      if ( this.ensureCanHide() ) {
        this.isShow = false;
      }
    },
    scrollToTop: function () {
      var intervalId = setInterval(function () {
        if (window.pageYOffset + MOVE_Y > 0) {
          scrollBy(0, MOVE_Y);
        } else {
          scroll(0, 0);
          clearInterval(intervalId);
        }
      }, 10);
    },
  },
  template: '<a class="btn-floating btn-large waves-effect waves-light cursor-pointer scroll-to-top" '
    + 'v-show="isShow" @click="scrollToTop">'
    + '<i class="material-icons">keyboard_arrow_up</i></a>',
};
