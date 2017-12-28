'use strict';

var util = {};

util.inherit = function (base, child) {
  child.prototype = Object.create(base.prototype);
  child.prototype.constructor = child;
};

util.mixin = function (trait, consume) {
  Object.keys(trait).forEach(function (element) {
    consume.prototype[element] = trait[element];
  });
};

util.toCamelCase = function (str) {
  var cameled = str.split('_').map(function (elem) {
    return elem.charAt(0).toUpperCase() + elem.slice(1);
  }).join('');
  return cameled.charAt(0).toLowerCase() + cameled.slice(1);
};

module.exports = util;

