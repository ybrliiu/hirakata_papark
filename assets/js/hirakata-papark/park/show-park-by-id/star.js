'use strict';

var Vue = require('vue');
var superagent = require('superagent');

/*
 * args: {
 *   isUserAuthed: Bool,
 *   isUserStared: Bool,
 *   starNum: Int,
 *   park: Object,
 *   rootUrl: Str,
 * };
 */

module.exports = function (args) {
  return new Vue({
    el: '#v-park-star',
    data: {
      isUserAuthed: args.isUserAuthed,
      isUserStared: args.isUserStared,
      starNum: args.starNum,
      addStarUrl: args.rootUrl + '/user/add-park-star/' + args.park.id,
      removeStarUrl: args.removeStarUrl + '/user/remove-park-star/' + args.park.id,
    },
    methods: {
      starIcon: function () {
        return this.isUserStared ? 'star' : 'star_border';
      },
      send: function (url) {
        superagent
          .post(url)
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
      },
      clickStar: function () {
        if (this.isUserAuthed) {
          var url = this.isUserStared ? this.removeStarUrl : this.addStarUrl;
          this.send(url);
        }
      },
    },
  });
};
