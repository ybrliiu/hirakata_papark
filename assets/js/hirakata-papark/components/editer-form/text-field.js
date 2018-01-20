'use strict';

module.exports = {
  props: {
    value: {
      type: String,
      default: '',
    },
  },
  data: function () {
    return {
      errors: [],
    };
  },
  methods: {
    onFetchResponceComplete: function (errors) {
      this.errors = errors[this.name].messages;
    },
    updateValue: function () {
      this.$emit('update', this.value);
    },
  },
  template: '<div class="left-align">'
    + '<input type="text" v-model="value" @change="updateValue">'
      + '<ul class="errors">'
        + '<li class="red-text" v-for="err in errors" '
          + '@fetch-responce-complete="onFetchResponceComplete">'
          + '{{ err }}'
        + '</li>'
      + '</ul>'
    + '</div>',
};
