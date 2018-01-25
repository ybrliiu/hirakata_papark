'use strict';

var superagent = require('superagent');

var ResponceFetcher = function () {
  this.url = '';
  this.formParts = [];
};

var PROTOTYPE = ResponceFetcher.prototype;

PROTOTYPE.setUrl = function (url) {
  this.url = url;
};

PROTOTYPE.addFormParts = function (formParts) {
  this.formParts.push(formParts);
};

PROTOTYPE.clearErrors = function () {
  this.formParts.forEach(function (formParts) {
    formParts.clearErrors;
  });
};

PROTOTYPE.sendData = function () {
  var sendData = {};
  this.formParts.forEach(function (formParts) {
    if (formParts.lang === undefined) {
      sendData[formParts.name] = formParts.value;
    } else {
      if (sendData[formParts.lang] === undefined) {
        sendData[formParts.lang] = {};
      }
      sendData[formParts.lang][formParts.name] = formParts.value;
    }
  });
  return sendData;
};

PROTOTYPE.fetchResponce = function () {
  superagent
    .post(this.url)
    .send(this.sendData())
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
        console.log(res);
      }
    }.bind(this));
};

module.exports = ResponceFetcher;
