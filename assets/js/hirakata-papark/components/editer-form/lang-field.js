'use strict';

module.exports = {
  props: {
    lang: {
      type: String,
      required: true,
    },
  },
  methods: {
    addError: function (errors) {
      this.errors = errors[this.lang][this.name].messages;
    },
  },
};
