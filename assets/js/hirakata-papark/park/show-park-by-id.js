'use strict';

var menu = require('./show-park-by-id/menu');
var star = require('./show-park-by-id/star');
var navBar = require('./show-park-by-id/nav-bar');

/*
 * args: {
 *   park: Object { id, x, y },
 *   rootUrl: Str,
 * }
 */

module.exports = function (args) {
  var rootUrl = args.rootUrl;
  var park = args.park;
  return {
    menu: menu,
    star: function (args) {
      args.rootUrl = rootUrl;
      args.park = park;
      return star(args);
    },
    navBar: function (args) {
      args.rootUrl = rootUrl;
      args.park = park;
      return navBar(args);
    },
  };
};

