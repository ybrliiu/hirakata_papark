'use strict';

var Vue = require('vue');
var superagent = require('superagent');

/*
 * args: {
 *   getCommentsUrl: Str,
 *   addCommentUrl: Str,
 *   isUserAuthed: Bool,
 *   isUserStared: Bool,
 *   starNum: Int,
 *   addStarUrl: Str,
 * };
 */

module.exports = function (args) {

  var parkStar = new Vue({
    el: '#v-park-star',
    data: {
      isUserAuthed: args.isUserAuthed,
      isUserStared: args.isUserStared,
      starNum: args.starNum,
      addStarUrl: args.addStarUrl,
    },
    methods: {
      starIcon: function () {
        return this.isUserStared ? 'star' : 'star_border';
      },
      clickStar: function () {
        if (this.isUserAuthed) {
          if (this.isUserStared) {
          } else {
            superagent
              .post(this.addStarUrl)
              .end(function (err, res) {
                var json = JSON.parse(res.text);
                if (json.is_success) {
                  this.isUserStared = !this.isUserStared;
                  this.starNum += this.isUserStared ? 1 : -1;
                } else {
                  console.log('通信失敗');
                  console.log(json);
                }
              }.bind(this));
          }
        }
      },
    },
  });
  
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

