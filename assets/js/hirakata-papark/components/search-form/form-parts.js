'use strict';

// [mixin]

module.exports = function (share) {
  return {
    props: {
      name: {
        type: String,
        required: true,
      },
    },
    data: function () {
      return { sharedState: share.state };
    },
  };
};
