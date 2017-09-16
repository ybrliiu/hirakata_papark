(function () {

  'use strict';

  hirakataPapark.namespace('ParkMap');

  var DEFAULT_Y = 34.8164259;
  var DEFAULT_X = 135.6475998;
  var DEFAULT_ZOOM = 13;
  var MAX_ZOOM = 18;
  var TILE_MAP_URL = 'https://cyberjapandata.gsi.go.jp/xyz/std/{z}/{x}/{y}.png';
  var CURRENT_LOCATION_ICON = L.icon({
    iconUrl: 'css/images/current-marker-icon.png',
    iconSize: [25, 41],
    iconAnchor: [0, 0],
    popupAnchor: [14, -10],
    shadowUrl: 'css/images/marker-shadow.png',
    shadowSize: [41, 41],
    shadowAnchor: [0, 0]
  });
  
  /*
    args : {
      id: map element id,
      url: park url,
    }
  */

  hirakataPapark.ParkMap = function (args) {
    this.url = args.url;
    this.mapId  = args.mapId;
    this.parkMap = L.map(this.mapId).setView([DEFAULT_Y, DEFAULT_X], DEFAULT_ZOOM);
    L.tileLayer(TILE_MAP_URL, {
      maxZoom: MAX_ZOOM,
      attribution: 'Map data by <a href="http://maps.gsi.go.jp/development/ichiran.html" target="_blank">地理院タイル</a>',
      id: '',
    }).addTo(this.parkMap);
  };

  var PROTOTYPE = hirakataPapark.ParkMap.prototype;

  PROTOTYPE.registParkMarkers = function (parks) {
    parks.forEach(function (park) {
      L.marker([park.y, park.x]).addTo(this.parkMap).bindPopup('<a href="' + this.url + park.id + '">' + park.name + '</a>');
    }.bind(this));
  };

  PROTOTYPE.registCurrentLocation = function () {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function (position) {
        var coords = position.coords;
        L.marker([coords.latitude, coords.longitude]).addTo(this.parkMap).setIcon(CURRENT_LOCATION_ICON).bindPopup('現在地').openPopup();
        this.parkMap.setView([coords.latitude, coords.longitude], 13);
      }.bind(this));
    } else {
      alert("お使いの ブラウザ / 端末 では位置情報の取得ができません。");
    }
  };

  PROTOTYPE.setView = function (y, x) {
    this.parkMap.setView([y, x], MAX_ZOOM);
  };

  /*
    leafret 搭載機能の現在地取得関数
            Android chrome では機能しなかった
    this.parkMap.on('locationfound', function (e) {
      L.marker(e.latlng).addTo(this.parkMap).setIcon(CURRENT_LOCATION_ICON).bindPopup('現在地').openPopup();
      this.parkMap.setView(e.latlng, 13);
  	}.bind(this));
    this.parkMap.on('locationerror', function (e) { alert("現在地の取得ができませんでした。"); });
  */

}());
