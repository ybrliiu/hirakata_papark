'use strict';

module.exports = function (formPartsMixin) {
  return {
    mixins: [formPartsMixin],
    props: {
      value: {
        type: String,
        required: true,
      },
    },
    created: function () {
      if (this.sharedState.sendData[this.name] === undefined) {
        this.sharedState.sendData[this.name] = [];
      }
      this.$set(this.sharedState.sendData, this.name, this.sharedState.sendData[this.name]);
    },
    template: '<div class="col l3 s6">'
      + '<input type="checkbox" class="filled-in" :id="value" :value="value" v-model="sharedState.sendData[name]">'
      + '<label v-bind:for="value">{{ value }}</label>'
      + '</div>',
  };
};

