(function () {

  'use strict';

  new Vue({
    mixins: [hirakataPapark.searcher.searchFormMixin, hirakataPapark.searcher.checkBoxesFormMixin],
    el: '#search-equipment',
    methods: {
      query: function () { return {equipments: this.items} },
    },
  });

}());
