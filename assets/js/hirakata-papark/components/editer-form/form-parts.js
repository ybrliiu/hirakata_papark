'use strict';

module.exports = function (responceFetcher) {
  return {
    props: {
      name: {
        type: String,
        required: true,
      },
      defaultValue: {
        type: String,
        default: '',
      },
    },
    data: function () {
      return {
        value: this.defaultValue,
        errors: [],
      };
    },
    created: function () {
      responceFetcher.addFormParts(this);
    },
    methods: {
      clearErrors: function () {
        this.errors.splice(0, this.errors.length);
      },
      pushError: function (value) {
        this.errors.push(value);
      },
    },
  };
};
