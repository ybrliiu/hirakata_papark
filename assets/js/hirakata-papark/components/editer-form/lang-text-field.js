'use strict';

var langParts = require('./lang-parts');
var textFieldCreater = require('./text-field');

module.exports = function (responceFetcher) {
  var textField = textFieldCreater(responceFetcher);
  return {
    mixins: [textField, langParts],
  };
};
