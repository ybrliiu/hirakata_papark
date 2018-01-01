'use strict';

module.exports = {
  util: require('./hirakata-papark/util'),
  menu: require('./hirakata-papark/menu'),
  ParkMap: require('./hirakata-papark/park-map'),
  searcher: function () { return require('./hirakata-papark/searcher') },
  currentLocation: function () { return require('./hirakata-papark/current-location') },
  user: function () { return require('./hirakata-papark/user') },
  park: function () { return require('./hirakata-papark/park') },
};
