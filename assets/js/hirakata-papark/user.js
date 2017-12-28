'use strict';

module.exports = {
  register: require('./user/register'),
  twitterRegisterModifiable: require('./user/twitter/register-modifiable'),
  session: require('./user/session'),
  parkTagger: require('./user/park-tagger'),
  parkImagePoster: require('./user/park-image-poster'),
  myPage: require('./user/mypage'),
};
