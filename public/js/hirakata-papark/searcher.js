(function () {

  'use strict';

  hirakataPapark.namespace('searcher');
  hirakataPapark.searcher = {};
  var PACKAGE = hirakataPapark.searcher;

  PACKAGE.searchFormMixin = {
    data: {
      showResult: false,
      result: '',
    },
    methods: {
      send: function (url) {
        if ( !this.isFormEmpty() ) {
          window.superagent
            .post(url)
            .query(this.query())
            .end(function (err, res) {
              this.showResult = true;
              this.result = res.text;
            }.bind(this));
        }
      },
    },
  };

  PACKAGE.checkBoxesFormMixin = {
    data: {
      items: [],
    },
    methods: {
      isFormEmpty: function () {
        return this.items.length === 0;
      },
    },
  };

}());

