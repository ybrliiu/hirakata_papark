package HirakataPapark::Service::User::Regist::MessageData {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Validator::MessageData;
  use HirakataPapark::Validator::DefaultMessageData;

  with 'HirakataPapark::Validator::MessageDataDelegator';

  has 'default_data' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Validator::DefaultMessageData',
    lazy    => 1,
    default => sub ($self) {
      HirakataPapark::Validator::DefaultMessageData->instance;
    },
  );

  sub create_japanese_data($self) {
    state $data = HirakataPapark::Validator::MessageData->new({
      $self->default_data->create_japanese_data->%*,
      message => {
        'id.regexp'       => q{[_1]は英数字及び'_', '-'からなる文字列を入力して下さい。},
        'password.regexp' => q{[_1]は英字を1文字以上, 数字を1文字以上含むように入力して下さい。},
      },
    });
  }

  sub create_english_data($self) {
    state $data = HirakataPapark::Validator::MessageData->new({
      $self->default_data->create_english_data->%*,
      message => {
        'id.regexp'       => q{Please enter a character string consisting of alphanumeric characters and '_', '-' for [_1]},
        'password.regexp' => q{Please enter [_1] so that it contains at least one alphabetic character and least one letter.},
      },
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

