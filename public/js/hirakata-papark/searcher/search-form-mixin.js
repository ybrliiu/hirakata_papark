'use strict';

var superagent = require('superagent');

module.exports = {
  data: {
    showResult: false,
    result: '',
  },
  methods: {
    send: function (url) {
      if ( !this.isFormEmpty() ) {
        superagent
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

