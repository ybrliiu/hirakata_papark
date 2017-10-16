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
      items: (function () {
        var items = {};
        Array.prototype.forEach.call(document.getElementById('check-boxes').children, function (checkBox) {
          items[checkBox] = false;
        });
        return items;
      }()),
      sendItems: [],
    },
    methods: {
      getSendItems: function () {
        return Object.keys(this.items).filter(function (key) {
          return this.items[key];
        }.bind(this));
      },
      isFormEmpty: function () {
        this.sendItems = this.getSendItems();
        return this.sendItems.length === 0;
      },
    },
  };

}());

