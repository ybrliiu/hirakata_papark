'use strict';

module.exports = function () {
  var storeFactory = require('./nav-bar-tabs/store');
  var navBarTabsFactory = require('./nav-bar-tabs/nav-bar-tabs');
  var tabsFactory = require('./nav-bar-tabs/tab');
  var store = storeFactory();
  return {
    navBarTabs: require('./nav-bar-tabs/nav-bar-tabs'),
    tabs: tabsFactory(store),
    navBarTabs: navBarTabsFactory(store),
  };
};

