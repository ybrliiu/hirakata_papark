'use strict';

var Vue = require('vue');
var superagent = require('superagent');

/*
 * args: {
 *   getCommentsUrl: Str,
 *   addCommentUrl: Str,
 * };
 */

module.exports = function (args) {
  
  var comment = new Vue({
    el: '#comment',
    data: {
      comments: '',
    },
    created: function () {
      this.getComments();
    },
    methods: {
      getComments: function () {
        superagent
          .get(args.getCommentsUrl)
          .end( function (err, res) {
            this.comments = res.text;
          }.bind(this) );
      },
    },
  });
  
  var commentForm = new Vue({
    el: '#comment-form',
    data: {
      name: '',
      message: '',
      result: '',
    },
    methods: {
      send: function () {
        superagent
          .post(args.addCommentUrl)
          .type('form')
          .send({
            name: this.name,
            message: this.message,
          })
          .end(function (err, res) {
            comment.getComments();
          }.bind(this));
      },
    },
  });

};

