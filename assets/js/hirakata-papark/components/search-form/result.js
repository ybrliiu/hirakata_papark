'use strict';

module.exports = function (share) {
  return {
    props: {
      title: {
        type: String,
        required: true,
      },
    },
    data: function () {
      return {
        value: '',
        sharedState: share.state,
      };
    },
    created: function () {
      ['isShowResult', 'result'].forEach(function (key) {
        this.$set(this.sharedState, key, this.sharedState[key]);
      }.bind(this));
    },
    template: '<div class="row">'
      + '<h3 v-if="sharedState.isShowResult">{{ title }}</h3>'
      + '<div class="col s12" v-html="sharedState.result"></div>'
      + '</div>',
  };
};

