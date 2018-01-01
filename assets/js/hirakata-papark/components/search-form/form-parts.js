'use strict';

// [mixin]
// required data or props
//   value: String

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
