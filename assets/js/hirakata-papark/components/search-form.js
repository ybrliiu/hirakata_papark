'use strict';

module.exports = function () {
  var storeFactory = require('./search-form/store');
  var store = storeFactory();
  var buttonFactory = require('./search-form/button');
  var checkboxFactory = require('./search-form/checkbox');
  var textFieldFactory = require('./search-form/text-field');
  var resultFactory = require('./search-form/result');
  return {
    searchForm: require('./search-form/search-form'),
    textField: textFieldFactory(store),
    checkbox: checkboxFactory(store),
    searchButton: buttonFactory(store),
    result: resultFactory(store),
  };
};

