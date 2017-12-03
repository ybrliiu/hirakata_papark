(function () {

  'use strict';

  new Vue({
    mixins: [hirakataPapark.searcher.searchFormMixin, hirakataPapark.searcher.checkBoxesFormMixin],
    el: '#search-tag',
    methods: {
      query: function () { return {tags: this.items} },
    },
  });

}());
