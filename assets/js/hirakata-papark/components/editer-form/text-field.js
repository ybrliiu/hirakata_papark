'use strict';

var formPartsMixinCreater = require('./form-parts');

module.exports = function (responceFetcher) {
  var formPartsMixin = formPartsMixinCreater(responceFetcher);
  return {
    mixins: [formPartsMixin],
    template: '<div>'
      + '<input type="text" v-model="value">'
        + '<ul class="errors">'
          + '<li class="red-text" v-for="err in errors">'
            + '{{ err }}'
          + '</li>'
        + '</ul>'
      + '</div>',
  };
};
