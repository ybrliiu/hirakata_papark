'use strict';

var superagent = require('superagent');

var ResponceFetcher = function () {
  this.url = '';
  this.formParts = {};
};

var PROTOTYPE = ResponceFetcher.prototype;

PROTOTYPE.setUrl = function (url) {
  this.url = url;
};

PROTOTYPE.addFormParts = function (formParts) {
  if (formParts.lang === undefined) {
    this.formParts[formParts.name] = formParts;
  } else {
    if ( this.formParts[formParts.lang] === undefined ) {
      this.formParts[formParts.lang] = {};
    }
    this.formParts[formParts.lang][formParts.name] = formParts;
  }
};

PROTOTYPE.clearErrors = function () {
  Object.keys(this.formParts).forEach(function (key) {
    var formParts = this.formParts[key];
    if (formParts.name === key) {
      this.formParts[key].clearErrors();
    } else {
      var langRecord = formParts;
      Object.keys(langRecord).forEach(function (key) {
        langRecord[key].clearErrors();
      });
    }
  }.bind(this));
};

PROTOTYPE.sendData = function () {
  var sendData = {};
  Object.keys(this.formParts).forEach(function (key) {
    var formParts = this.formParts[key];
    if (formParts.name === key) {
      sendData[formParts.name] = formParts.value;
    } else {
      var lang = key;
      var langRecord = formParts;
      if (sendData[lang] === undefined) {
        sendData[lang] = {};
      }
      Object.keys(langRecord).forEach(function (key) {
        var formParts = langRecord[key];
        sendData[formParts.lang][formParts.name] = formParts.value;
      });
    }
  }.bind(this));
  return sendData;
};

PROTOTYPE.setErrors = function (errors) {
  var self = this;
  Object.keys(errors).forEach(function (key) {
    var error = errors[key];
    if (error.messages === undefined) {
      var lang = key;
      var langRecordErrors = error;
      Object.keys(error).forEach(function (key) {
        var error = langRecordErrors[key];
        error.messages.forEach(function (message) {
          self.formParts[lang][error.name].pushError(message);
        });
      });
    } else {
      error.messages.forEach(function (message) {
        self.formParts[error.name].pushError(message);
      });
    }
  });
};

PROTOTYPE.fetchResponce = function () {
  superagent
    .post(this.url)
    .send(this.sendData())
    .end(function (err, res) {
      this.clearErrors();
      if (res.status !== 200) {
        alert('サーバーでエラーが発生しました。運営者に報告してください。');
        console.log('[Error ocurred at searchForm.button.fetchResponce]');
        console.log({
          object: this,
          err: err,
          res: res,
        });
      } else {
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
          location.assign(json.redirect_to);
        } else {
          this.setErrors(json.errors);
        }
      }
    }.bind(this));
};

module.exports = ResponceFetcher;
