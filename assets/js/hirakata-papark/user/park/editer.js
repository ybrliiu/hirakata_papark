'use strict';

var Vue = require('vue');
var VTooltip = require('v-tooltip');
var ResponceFetcher = require('../../components/editer-form/responce-fetcher');
var editerButtonCreater = require('../../components/editer-form/button');
var textFieldCreater = require('../../components/editer-form/text-field');
var langTextFieldCreater = require('../../components/editer-form/lang-text-field');

module.exports = function () {
  Vue.use(VTooltip);
  var responceFetcher = new ResponceFetcher;
  return new Vue({
    el: '#v-park-editer',
    components: {
      editerButton: editerButtonCreater(responceFetcher),
      textField: textFieldCreater(responceFetcher),
      langTextField: langTextFieldCreater(responceFetcher),
    },
  });
};

