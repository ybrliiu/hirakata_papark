'use strict';

module.exports = function (share) {
  return {
    props: {
      name: {
        type: String,
        required: true,
      },
      value: {
        type: String,
        required: true,
      },
    },
    data: function () {
      return {
        sharedState: share.state,
      };
    },
    created: function () {
      if (this.sharedState.sendData[this.name] === undefined) {
        this.sharedState.sendData[this.name] = [];
      }
      this.$set(this.sharedState.sendData, this.name, this.sharedState.sendData[this.name]);
    },
    template: '<div class="col l3 s6"><input type="checkbox" class="filled-in" v-bind:id="value" v-bind:value="value" v-model="sharedState.sendData[name]">'
      + '<label v-bind:for="value">{{ value }}</label></div>',
  };
};

