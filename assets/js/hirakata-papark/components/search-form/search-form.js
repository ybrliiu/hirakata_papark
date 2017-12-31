'use strict';

module.exports = {
  props: {
    title: {
      type: String,
      required: true,
    },
  },
  template: '<div><h2>{{ title }}</h2><slot></slot></div>',
};
