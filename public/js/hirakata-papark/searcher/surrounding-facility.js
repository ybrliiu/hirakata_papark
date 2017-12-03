(function () {

  'use strict';

  new Vue({
    mixins: [hirakataPapark.searcher.searchFormMixin, hirakataPapark.searcher.checkBoxesFormMixin],
    el: '#search-surrounding-facility',
    methods: {
      query: function () { return {surrounding_facilities: this.items} },
    },
  });

}());
