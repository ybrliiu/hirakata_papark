'use strict';

module.exports = function (store) {
  return {
    data: function () {
      var tabVnodes = this.$slots.default.filter(function (vnode) {
        return vnode.componentOptions;
      });
      var tabTitles = tabVnodes.map(function (vnode) {
        return vnode.componentOptions.propsData.title;
      });
      return {
        tabs: {},
        tabTitles: tabTitles,
        tabVnodes: tabVnodes,
      };
    },
    created: function () {
      this.tabTitles.forEach(function (title) {
        store.addTab(title);
      });
      this.tabTitles.forEach(function (title) {
        this.$set(this.tabs, title, store.getTab(title));
      }.bind(this));
      store.setActiveTab(this.tabTitles[0]);
    },
    render: function (elementCreater) {
      var navBarNodes = elementCreater(
        'div',
        { 'class': ['park-nav-bar'] },
        [ elementCreater('ul',{'class': ['tabs']}, [this.$slots.default] ) ]
      );
      var contentsNodes = this.tabVnodes.map(function (vnode) {
        var title = vnode.componentOptions.propsData.title;
        var children = vnode.componentOptions.children;
        if (children instanceof Array) {
          return elementCreater(
            'div',
            {
              'class': 'nav-bar-tabs-content',
              directives: [{
                name: 'show',
                value: this.tabs[title].isActive,
              }],
            },
            children
          );
        } else {
          return undefined;
        }
      }.bind(this)).filter(function (vnodes) { return vnodes !== undefined; });
      return elementCreater(
        'div',
        {'class': 'nav-bar-tabs-wrapper'},
        [navBarNodes, contentsNodes]
      );
    }
  };
};

