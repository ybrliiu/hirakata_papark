'use strict';

module.exports = function () {
  var storeFactory = require('./search-form/store');
  var store = storeFactory();
  var buttonFactory = require('./search-form/button');
  var resultFactory = require('./search-form/result');
  var formPartsMixinFactory = require('./search-form/form-parts');
  var formPartsMixin = formPartsMixinFactory(store);
  var textFieldFactory = require('./search-form/text-field');
  var selectValueFactory = require('./search-form/select-value');
  var checkboxFactory = require('./search-form/checkbox');
  return {
    sharedState: store.state,
    searchForm: require('./search-form/search-form'),
    searchButton: buttonFactory(store),
    result: resultFactory(store),
    textField: textFieldFactory(formPartsMixin),
    selectValue: selectValueFactory(formPartsMixin),
    checkbox: checkboxFactory(formPartsMixin),
  };
};

