'use strict';

var hirakataPapark = hirakataPapark || {};

// なぜかnameSpaceだと上手く行かない...(予約語？)
hirakataPapark.namespace = function (pkgName) {

  var parts = pkgName.split('.');
  var parent = hirakataPapark;

  if (parts[0] === 'hirakataPapark') {
    parts = parts.slice(1);
  }

  for (var i = 0; i < parts.length; i++) {
    if (typeof parent[parts[i]] === "undefined") {
      parent[parts[i]] = {};
    }
    parent = parent[parts[i]];
  }

};

hirakataPapark.inherit = function (base, child) {
  child.prototype = Object.create(base.prototype);
  child.prototype.constructor = child;
};

hirakataPapark.mixin = function (trait, consume) {
  Object.keys(trait).forEach(function (element) {
    consume.prototype[element] = trait[element];
  });
};

