(function () {

  'use strict';

  new Vue({
    el: '#search-plants',
    data: {
      plants: [],
      plantsCategories: [],
      showResult: false,
      result: '',
    },
    methods: {
      send: function (url, query, sendItems) {
        if (sendItems.length !== 0) {
          window.superagent
            .post(url)
            .query(query)
            .end(function (err, res) {
              this.showResult = true;
              this.result = res.text;
            }.bind(this));
        }
      },
      sendToPlantsSearcher: function (url) {
        this.send(url, {plants: this.plants}, this.plants);
      },
      sendToPlantsCategoriesSearcher: function (url) {
        this.send(url, {plants_categories: this.plantsCategories}, this.plantsCategories);
      },
    },
  });

}());
