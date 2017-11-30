package HirakataPapark::Service::User::Regist::ValidatorMessageDataFactory {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args_pos );
  use HirakataPapark::Validator::MessageData;
  use HirakataPapark::Validator::MessageDataFactory;

  with 'HirakataPapark::Role::Singleton';

  my %LANG_TO_DATA_TABLE = (
    ja => create_japanese_data(),
    en => create_english_data(),
  );

  sub message_data {
    args_pos my $class, my $lang => 'HirakataPapark::lang';
    $LANG_TO_DATA_TABLE{$lang};
  }

  sub create_japanese_data {
    state $data = HirakataPapark::Validator::MessageData->new({
      HirakataPapark::Validator::MessageDataFactory->create_japanese_data->%*,
      message => {
        'id.regexp'       => q{[_1]は英数字及び'_', '-'からなる文字列を入力して下さい。},
        'password.regexp' => q{[_1]は英字を1文字以上, 数字を1文字以上含むように入力して下さい。},
      },
    });
  }

  sub create_english_data {
    state $data = HirakataPapark::Validator::MessageData->new({
      HirakataPapark::Validator::MessageDataFactory->create_english_data->%*,
      message => {
        'id.regexp'       => q{Please enter a character string consisting of alphanumeric characters and '_', '-' for [_1]},
        'password.regexp' => q{Please enter [_1] so that it contains at least one alphabetic character and least one letter.},
      },
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

