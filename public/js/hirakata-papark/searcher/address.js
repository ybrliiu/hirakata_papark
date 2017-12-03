(function () {

  'use strict';

  new Vue({
    mixins: [hirakataPapark.searcher.searchFormMixin],
    el: '#search-address',
    data: { parkAddress: '' },
    methods: {
      isFormEmpty: function () { return this.parkAddress === '' },
      query: function () { return {park_address: this.parkAddress} },
    },
  });

}());

