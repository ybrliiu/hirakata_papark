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
        'id.regexp'       => q{使用できる文字は半角英数字及び'_', '-'です。},
        'password.regexp' => q{使用できる文字は半角英数字、記号で、数字を必ず1文字以上含めて下さい。},
      },
    });
  }

  sub create_english_data($self) {
    state $data = HirakataPapark::Validator::MessageData->new({
      $self->default_data->create_english_data->%*,
      message => {
        'id.regexp'       => q{You can use alphanumeric and '_', '-'.},
        'password.regexp' => q{You can use alphanumeric and symbols and be sure to include one or more numbers.},
      },
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

