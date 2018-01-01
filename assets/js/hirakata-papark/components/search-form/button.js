'use strict';

var superagent = require('superagent');

module.exports = function (share) {
  return {
    props: {
      url: {
        type: String,
        required: true,
      },
      sendFieldName: {
        type: String,
        required: true,
      },
    },
    data: function () {
      return {
        sharedState: share.state,
        classObjects: {
          'waves-effect': true,
          'btn': true,
        },
      };
    },
    mounted: function () {
      Object.keys(this.sharedState.sendData).forEach(function (key) {
        this.$set(this.sharedState.sendData, key, this.sharedState.sendData[key]);
      }.bind(this));
    },
    methods: {
      fetchResponce: function () {
        var sendObject = {};
        sendObject[this.sendFieldName] = this.sharedState.sendData[this.sendFieldName];
        superagent
          .post(this.url)
          .type('form')
          .send(sendObject)
          .end(function (err, res) {
            if (res.status === 404) {
              alert('サーバーでエラーが発生しました。運営者に報告してください。');
              console.log('[Error ocurred at searchForm.button.fetchResponce]');
              console.log({
                object: this,
                err: err,
                res: res,
              });
            } else {
              this.sharedState.isShowResult = true;
              this.sharedState.result = res.text;
            }
          }.bind(this));
      },
    },
    template: '<button class="wave-effect" @click="fetchResponce">'
      + '<i class="material-icons">search</i>'
      + '</button>',
  };
};
