'use strict';

var superagent = require('superagent');

module.exports = {
  props: {
    url: {
      type: String,
      required: true,
    },
  },
  data: function () {
    return {};
  },
  methods: {
    filterVnodes: function (tagName) {
      return this.$slots.default.filter(function (vnode) {
        if (vnode.componentOptions !== undefined) {
          return vnode.componentOptions.tag === tagName;
        } else {
          return false;
        }
      });
    },
    sendFields: function () {
      var sendFields = {};
      this.filterVnodes('lang-text-field').forEach(function (vnode) {
        console.log(vnode);
        // sendFields[vnode.componentOptions.tag] = [];
      });
      this.filterVnodes('text-field').forEach(function (vnode) {
      });
      return sendFields;
    },
    onFetchResponce: function () {
      superagent
        .post(this.url)
        .send(this.sendFields())
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
            this.$emit('onFetchResponce', errors);
          }
        }.bind(this));
    },
    fetchResponce: function () {
      this.onFetchResponce();
    },
  },
  template: '<button class="wave-effect" @click="fetchResponce">'
    + '<i class="material-icons">send</i>'
    + '</button>',
};
