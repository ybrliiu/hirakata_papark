(function () {

  'use strict';

  new Vue({
    mixins: [hirakataPapark.searcher.searchFormMixin],
    el: '#search-name',
    data: { parkName: '' },
    methods: {
      isFormEmpty: function () { return this.parkName === '' },
      query: function () { return {park_name: this.parkName} },
    },
  });

}());

