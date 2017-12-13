'use strict';

var Vue = require('vue');
var superagent = require('superagent');

module.exports = function (removeStarUrl) {
  var favoriteParksListId = 'v-favorite-parks-list';
  new Vue({
    el: '#' + favoriteParksListId,
    data: {
      showList: {},
    },
    created: function () {
      var list = document.getElementById(favoriteParksListId).getElementsByTagName('li');
      Array.prototype.forEach.call(list, function (el) {
        var parkId = el.getAttribute('data-park-id');
        this.showList[parkId] = true;
      }.bind(this));
    },
    methods: {
      remove: function (parkId) {
        superagent
          .post(removeStarUrl + '/' + parkId)
          .end(function (err, res) {
            var json = JSON.parse(res.text);
            if (json.is_success) {
              this.updateList(parkId);
            } else {
              alert('park star remove failed');
              console.log(json);
            }
          }.bind(this));
      },
      updateList: function (parkId) {
        // objectの中身いじるだけではvueに変更を検知されないので
        // cloneしてあたらしいobject代入
        // (park listをjsonとして吐き出して v-for でやったほうが綺麗かも知れない)
        var showList = {};
        Object.keys(this.showList).forEach(function (el) {
          showList[el] = this.showList[el];
        }.bind(this));
        showList[parkId] = false;
        this.showList = showList;
      },
    },
  });
};
