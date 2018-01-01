'use strict';

var util = require('../util');

/*
 * required data
 *   sendItems: Array
 *
 * required methods
 *   onFetchResponce(superagentで通信する処理)
 */

module.exports = {
  data: {
    isFetchingResponce: false,
  },
  methods: {
    clearErrors: function () {
      this.sendItems.map(function (elem) {
        return elem + 'Errors';
      }).forEach(function (elem) {
        this[elem] = [];
      }.bind(this));
    },
    isFormEmpty: function () {
      var emptyItems = this.sendItems.filter(function (elem) {
        return this[elem] === '';
      }.bind(this));
      return emptyItems.length === this.sendItems.length;
    },
    canFetchResponce: function () {
      return !this.isFetchingResponce && !this.isFormEmpty();
    },
    fetchResponce: function () {
      if (this.canFetchResponce) {
        this.isFetchingResponce = true;
        this.onFetchResponce();
      }
    },
    onFetchResponceSuccess: function (json) {
      location.assign(json.redirect_to);
    },
    // superagent.end に渡すコールバックとして使える
    onFetchResponceComplete: function (err, res) {
      this.isFetchingResponce = false;
      this.clearErrors();
      var json;
      try {
        json = JSON.parse(res.text);
      } catch (e) {
        if (e instanceof SyntaxError) {
          alert('サーバーでエラーが発生しました。サイト運営者に報告してください');
          console.log(e);
          console.log(res);
          return;
        } else {
          throw e;
        }
      }
      if (json.is_success) {
        this.onFetchResponceSuccess(json);
      } else {
        Object.keys(json.errors).forEach(function (key) {
          var error = json.errors[key];
          this[util.toCamelCase(error.name) + 'Errors'] = error.messages;
        }.bind(this));
      }
    },
  },
};

