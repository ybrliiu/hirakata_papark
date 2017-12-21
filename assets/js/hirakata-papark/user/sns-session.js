'use strict';

var Vue = require('vue');

module.exports = function () {
  return new Vue({
    el: '#v-sns-session-form',
    data: { OriginallySeenPage: '' },
    created: function () {
      var referrer = document.referrer;
      this.OriginallySeenPage = referrer === '' ? '../mypage' : referrer;
    },
  });
};
