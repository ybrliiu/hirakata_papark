'use strict';

module.exports = function (responceFetcher) {
  return {
    props: {
      url: {
        type: String,
        required: true,
      },
    },
    created: function () {
      responceFetcher.setUrl(this.url);
    },
    methods: {
      fetchResponce: function () {
        responceFetcher.fetchResponce();
      },
    },
    template: '<button class="wave-effect btn" @click="fetchResponce">'
      + '<i class="material-icons">send</i>'
      + '</button>',
  };
};
