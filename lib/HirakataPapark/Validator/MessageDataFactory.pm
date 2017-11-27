package HirakataPapark::Validator::MessageDataFactory {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Validator::MessageData;

  with 'HirakataPapark::Role::Singleton';

  sub create_japanese_data($self) {
    state $data = HirakataPapark::Validator::MessageData->new({
      param => {
        name        => '名前',
        id          => 'ID',
        password    => 'パスワード',
        address     => '住んでいる場所',
        profile     => 'プロフィール',
        twitter_id  => 'Twitter ID',
        facebook_id => 'Facebook ID',
      },
      message => {
        not_null      => '[_1]を入力してください。',
        int           => '[_1]には整数以外の値は入力できません。',
        length        => '[_1]が長すぎるか短すぎます。',
        ascii         => '[_1]には英数字及び半角記号しか使用できません。',
        choice        => '[_1]に想定外の値が入力されています。',
        already_exist => 'その[_1]は既に使用されています。',
      },
      function => {},
    });
  }

  sub create_english_data($self) {
    state $data = HirakataPapark::Validator::MessageData->new({
      param => {
        name        => 'Name',
        id          => 'ID',
        password    => 'Password',
        address     => 'Address',
        profile     => 'Profile',
        twitter_id  => 'Twitter ID',
        facebook_id => 'Facebook ID',
      },
      message => {
        not_null      => 'Please input [_1].',
        int           => 'You cannot enter value other than integers on the [_1].',
        length        => '[_1] is either too long or too short.',
        ascii         => 'Only alphanumeric characters and half-width symbols can be used in the [_1].',
        choice        => 'An unexpected value is entered for the [_1].',
        already_exist => 'The [_1] is already used.',
      },
      function => {},
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

