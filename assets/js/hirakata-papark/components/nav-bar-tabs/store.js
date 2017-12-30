'use strict';

module.exports = function () {
  return {
    tabs: {},
    getTab: function (title) {
      return this.tabs[title];
    },
    addTab: function (title) {
      this.tabs[title] = {
        title: title,
        isActive: false,
      };
    },
    isTabActive: function (title) {
      return this.tabs[title].isActive;
    },
    setActiveTab: function (title) {
      Object.keys(this.tabs).forEach(function (key) {
        this.tabs[key].isActive = false;
      }.bind(this));
      this.tabs[title].isActive = true;
    },
  };
};

