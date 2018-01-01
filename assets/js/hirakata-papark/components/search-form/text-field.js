'use strict';

module.exports = function (share) {
  return {
    props: {
      name: {
        type: String,
        required: true,
      },
      placeholder: {
        type: String,
        default: '',
      },
    },
    data: function () {
      return {
        value: '',
        sharedState: share.state,
      };
    },
    created: function () {
      this.$set(this.sharedState.sendData, this.name, '');
    },
    template: '<input v-model="sharedState.sendData[name]" :placeholder="placeholder" type="text">',
  };
};
