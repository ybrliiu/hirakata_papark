(function () {

  'use strict';

  new Vue({
    mixins: [hirakataPapark.searcher.searchFormMixin, hirakataPapark.searcher.checkBoxesFormMixin],
    el: '#search-form',
    methods: {
      query: function () { return {equipments: this.sendItems} },
    },
  });

}());
