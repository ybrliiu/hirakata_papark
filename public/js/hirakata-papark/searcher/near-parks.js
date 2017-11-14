(function () {

  'use strict';

  var INITIAL_DISTANCE = 200;

  new Vue({
    el: '#search-near-parks',
    data: {
      result: '',
      showResult: false,
      url: undefined,
      x: undefined,
      y: undefined,
      distance: INITIAL_DISTANCE,
    },
    created: function () {
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
          function (position) {
            var coords = position.coords;
            this.x = coords.longitude;
            this.y = coords.latitude;
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
    methods: {
      send: function () {
        if (this.url === undefined) {
          this.url = this.$el.getElementsByTagName('select')[0].getAttribute('action');
        }
        window.superagent
          .post(this.url)
          .query({
            x: this.x,
            y: this.y,
            distance: this.distance,
          })
          .end(function (err, res) {
            this.showResult = true;
            this.result = res.text;
          }.bind(this));
      },
    },
  });

}());

