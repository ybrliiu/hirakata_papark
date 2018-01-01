'use strict';

module.exports = function (formPartsMixin) {
  return {
    mixins: [formPartsMixin],
    props: {
      placeholder: {
        type: String,
        default: '',
      },
    },
    data: function () {
      return { value: '' };
    },
    created: function () {
      this.$set(this.sharedState.sendData, this.name, '');
    },
    template: '<input v-model="sharedState.sendData[name]" :placeholder="placeholder" type="text">',
  };
};
