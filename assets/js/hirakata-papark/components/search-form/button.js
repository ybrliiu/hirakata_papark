'use strict';

var superagent = require('superagent');

module.exports = function (store) {
  return {
    props: {
      url: {
        type: String,
        required: true,
      },
      sendField: {
        type: String,
        required: true,
      },
    },
    data: function () {
      return {
        sharedState: store.state,
        classObjects: {
          'waves-effect': true,
          'btn': true,
        },
        sendFields: this.sendField.split(' '),
      };
    },
    mounted: function () {
      Object.keys(this.sharedState.sendData).forEach(function (key) {
        this.$set(this.sharedState.sendData, key, this.sharedState.sendData[key]);
      }.bind(this));
    },
    methods: {
      onFetchResponce: function () {
        var sendObject = {};
        this.sendFields.forEach(function (key) {
          sendObject[key] = this.sharedState.sendData[key];
        }.bind(this));
        superagent
          .post(this.url)
          .type('form')
          .send(sendObject)
          .end(function (err, res) {
            if (res.status !== 200) {
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
      fetchResponce: function () {
        var undefinedFields = this.sendFields.map(function (key) {
          return this.sharedState.sendData[key] === undefined ? key : undefined;
        }.bind(this)).filter(function (elem) {
          return elem !== undefined;
        });
        if (undefinedFields.length === 0) {
          this.onFetchResponce();
        } else {
          alert('検索できません。');
          console.log('[Cant search]');
          console.log({ undefinedFields: undefinedFields });
        }
      },
    },
    template: '<button class="wave-effect" @click="fetchResponce">'
      + '<i class="material-icons">search</i>'
      + '</button>',
  };
};
