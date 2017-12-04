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

module.exports = util;

