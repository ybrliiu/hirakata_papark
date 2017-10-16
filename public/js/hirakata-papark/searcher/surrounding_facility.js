(function () {

  'use strict';

  new Vue({
    mixins: [hirakataPapark.searcher.searchFormMixin, hirakataPapark.searcher.checkBoxesFormMixin],
    el: '#search-form',
    methods: {
      query: function () { return {surrounding_facilities: this.sendItems} },
    },
  });

}());
