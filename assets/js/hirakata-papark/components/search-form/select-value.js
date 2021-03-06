'use strict';

module.exports = function (formPartsMixin) {
  return {
    mixins: [formPartsMixin],
    created: function () {
      this.$set(this.sharedState.sendData, this.name, this.sharedState.sendData[this.name]);
    },
    template: '<select class="browser-default" v-model="sharedState.sendData[name]" :disabled="disabled"><slot></slot></select>',
  };
};
