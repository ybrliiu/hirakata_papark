'use strict';

// [mixin]

module.exports = function (share) {
  return {
    props: {
      name: {
        type: String,
        required: true,
      },
      disabled: {
        type: Boolean,
        default: false,
      },
    },
    data: function () {
      return { sharedState: share.state };
    },
  };
};
