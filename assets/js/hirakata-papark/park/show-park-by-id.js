'use strict';

var Vue = require('vue');
var superagent = require('superagent');
var VueImages = require('vue-images');

// vue-images の body.style.position = 'fixed' にする挙動が気に入らないので上書きする
(function () {
  var isShow = VueImages.default.watch.isShow;
  VueImages.default.watch.isShow = function () {
    (isShow.bind(this))();
    document.body.style.position = 'static';
  };
}());

/*
 * args: {
 *   getCommentsUrl: Str,
 *   addCommentUrl: Str,
 *   isUserAuthed: Bool,
 *   isUserStared: Bool,
 *   starNum: Int,
 *   addStarUrl: Str,
 *   removeStarUrl: Str,
 *   images: Array[Image],
 * };
 */

module.exports = function (args) {

  var Z_INDEX = 500;
  var MENU_WIDTH = 200;
  var MENU_TOP_MARGIN = 5;
  var parkMenuId = 'v-park-menu';
  var parkMenu = new Vue({
    el: '#' + parkMenuId,
    data: {
      isOpened: false,
      menuStyleObject: {
        'font-size': 'initial',
        position: 'absolute',
        width: 0,
        display: 'none',
        top: '0px',
        left: '0px',
        right: '0px',
        'z-index': 0,
      },
    },
    created: function () {
      this.menuStyleObject.width = MENU_WIDTH + 'px';
      this.resize();
      window.addEventListener('click', function (eve) {
        eve.stopPropagation();
        this.closeMenu();
      }.bind(this));
      window.addEventListener('resize', function (eve) {
        this.resize();
      }.bind(this));
    },
    methods: {
      clickIcon: function (eve) {
        eve.stopPropagation();
        if (this.isOpened) {
          this.closeMenu();
        } else {
          this.openMenu();
        }
      },
      resize: function () {
        var rect = document.getElementById(parkMenuId).getElementsByTagName('i')[0].getBoundingClientRect();
        this.menuStyleObject.left = (rect.left - MENU_WIDTH + rect.width) + 'px';
        this.menuStyleObject.top = (rect.top + rect.height + MENU_TOP_MARGIN) + 'px';
      },
      openMenu: function () {
        this.isOpened = true;
        this.menuStyleObject.display = 'block';
        this.menuStyleObject['z-index'] = Z_INDEX;
      },
      closeMenu: function () {
        this.isOpened = false;
        this.menuStyleObject.display = 'none';
        this.menuStyleObject['z-index'] = 0;
      },
    },
  });

  var parkStar = new Vue({
    el: '#v-park-star',
    data: {
      isUserAuthed: args.isUserAuthed,
      isUserStared: args.isUserStared,
      starNum: args.starNum,
      addStarUrl: args.addStarUrl,
      removeStarUrl: args.removeStarUrl,
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
  
  var comment = new Vue({
    el: '#v-comment',
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
    el: '#v-comment-form',
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

  var images = new Vue({
    el: '#v-images',
    data: function () {
      return {
        images: args.images,
        modalclose: true,
        keyinput: true,
        mousescroll: true,
        showclosebutton: true,
        showcaption: true,
        imagecountseparator: 'of',
        showimagecount: true,
        showthumbnails: true,
      }
    },
    components: {
      vueImages: VueImages.default,
    },
  });

};

