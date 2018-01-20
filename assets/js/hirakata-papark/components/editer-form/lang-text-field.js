'use strict';

var langField = require('./lang-field');
var textField = require('./text-field');

module.exports = {
  mixins: [langField, textField],
};
