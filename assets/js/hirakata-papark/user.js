'use strict';

module.exports = {
  register: require('./user/register'),
  session: require('./user/session'),
  snsSession: require('./user/sns-session'),
  parkTagger: require('./user/park-tagger'),
  myPage: require('./user/mypage'),
};
