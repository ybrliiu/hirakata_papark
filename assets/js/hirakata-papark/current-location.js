'use strict';

var Vue = require('vue');
var superagent = require('superagent');
var searchForm = require('./components/search-form');
var searchFormComponents = searchForm();

module.exports = new Vue({
  el: '#v-search-near-parks',
  data: {
    sendData: searchFormComponents.sharedState.sendData,
    canSearch: false,
  },
  created: function () {
    // 200でフォームの距離を初期化
    this.sendData.distance = 200;
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        function (position) {
          var coords = position.coords;
          this.sendData.x = coords.longitude;
          this.sendData.y = coords.latitude;
          this.canSearch = true;
        }.bind(this),
        function () {
          var mes = '位置情報を取得できませんでした';
          alert(mes);
          throw(mes);
        }
      );
    } else {
      var mes = 'お使いの ブラウザ / 端末 では位置情報の取得ができません。';
      alert(mes);
      throw(mes);
    }
  },
  components: searchFormComponents,
});
