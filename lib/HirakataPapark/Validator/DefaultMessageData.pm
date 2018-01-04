package HirakataPapark::Validator::DefaultMessageData {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Validator::MessageData;
  use HirakataPapark::Model::MultilingualDelegator::LangDict::Common;

  with 'HirakataPapark::Validator::MessageDataDelegator';

  my $dict = HirakataPapark::Model::MultilingualDelegator::LangDict::Common->instance;

  sub create_japanese_data($self) {
    HirakataPapark::Validator::MessageData->new({
      param => $dict->lang_dict('ja')->words_dict,
      function => {
        not_null      => '[_1]を入力してください。',
        int           => '[_1]には整数以外の値は入力できません。',
        length        => '[_1]が長すぎるか短すぎます。',
        ascii         => '[_1]には英数字及び半角記号しか使用できません。',
        choice        => '[_1]に想定外の値が入力されています。',
        equal         => '[_1]が正しくありません。',
        already_exist => 'その[_1]は既に使用されています。',
      },
    });
  }

  sub create_english_data($self) {
    HirakataPapark::Validator::MessageData->new({
      param => $dict->lang_dict('en')->words_dict,
      function => {
        not_null      => 'Please input [_1].',
        int           => 'You cannot enter value other than integers on the [_1].',
        length        => '[_1] is either too long or too short.',
        ascii         => 'Only alphanumeric characters and half-width symbols can be used in the [_1].',
        choice        => 'An unexpected value is entered for the [_1].',
        equal         => 'Wrong [_1].',
        already_exist => 'The [_1] is already used.',
      },
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

