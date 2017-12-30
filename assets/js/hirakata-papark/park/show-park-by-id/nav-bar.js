'use strict';

var Vue = require('vue');
var superagent = require('superagent');
var VueImages = require('vue-images');
var ParkMap = require('../../park-map');
var vueNavBarTabs = require('../../components/nav-bar-tabs');

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
 *   park: Object(park),
 *   images: Array[Image],
 *   rootUrl: Str,
 * };
 */

module.exports = function (args) {

  var bus = new Vue();
  
  var comment = {
    data: function () {
      return {
        comments: '',
        getCommentsUrl: args.rootUrl + '/park/get-comments/' + args.park.id,
      };
    },
    created: function () {
      bus.$on('get-comments', function () {
        this.getComments();
      }.bind(this));
    },
    mounted: function () {
      this.getComments();
    },
    methods: {
      getComments: function () {
        superagent
          .get(this.getCommentsUrl)
          .end(function (err, res) {
            this.comments = res.text;
          }.bind(this));
      },
    },
    template: '#comment-template',
  };

  var commentForm = {
    data: function () {
      return {
        name: '',
        message: '',
        result: '',
        addCommentUrl: args.rootUrl + '/park/add-comment/' + args.park.id,
      }
    },
    methods: {
      send: function () {
        superagent
          .post(this.addCommentUrl)
          .type('form')
          .send({
            name: this.name,
            message: this.message,
          })
          .end(function (err, res) {
            bus.$emit('get-comments');
          }.bind(this));
      },
    },
    template: '#comment-form-template',
  };

  var newComponents = vueNavBarTabs();

  var navBarVm = new Vue({
    el: '#v-park-nav-bar',
    data: {
      images: args.images,
    },
    mounted: function () {
      var parkMap = new ParkMap({
        url: args.rootUrl + '/park/' + args.park.id,
        mapId: 'park-map-small',
      });
      parkMap.setView(args.park.y, args.park.x);
      parkMap.registParkMarkers([args.park]);
    },
    components: {
      vueNavBarTabs: newComponents.navBarTabs,
      tab: newComponents.tabs,
      vueImages: VueImages.default,
      comment: comment,
      commentForm: commentForm,
    },
  });

};

