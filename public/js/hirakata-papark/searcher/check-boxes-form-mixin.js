'use strict';

module.exports = {
  data: {
    items: [],
  },
  methods: {
    isFormEmpty: function () {
      return this.items.length === 0;
    },
  },
};

