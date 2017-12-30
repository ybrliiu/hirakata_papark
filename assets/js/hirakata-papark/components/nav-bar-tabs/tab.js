'use strict';

module.exports = function (store) {
  return {
    props: {
      title: {
        type: String,
        required: true,
      },
    },
    data: function () {
      return {
        virtual: store.getTab(this.title),
      };
    },
    methods: {
      clickTab: function () {
        store.setActiveTab(this.title);
      },
      isActive: function () {
        return this.virtual.isActive;
      },
    },
    template: '<li class="tab" v-on:click="clickTab"><a :class="{ active: isActive() }">{{ title }}</a></li>',
  };
};

