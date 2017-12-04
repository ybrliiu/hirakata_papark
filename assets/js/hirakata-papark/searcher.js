'use strict';

module.exports = {
  searchFormMixin: function () { return require('./searcher/search-form-mixin') },
  checkBoxesFormMixin: function () { return require('./searcher/check-boxes-form-mixin') },
  address: function () { return require('./searcher/address') },
  equipment: function () { return require('./searcher/equipment') },
  name: function () { return require('./searcher/name') },
  nearParks: function () { return require('./searcher/near-parks') },
  plants: function () { return require('./searcher/plants') },
  surroundingFacility: function () { return require('./searcher/surrounding-facility') },
  tag: function () { return require('./searcher/tag') },
};

