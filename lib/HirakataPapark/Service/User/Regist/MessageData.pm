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
    default => sub ($self) { HirakataPapark::Validator::DefaultMessageData->new },
  );

  sub create_japanese_data($self) {
    my $message_data = $self->default_data->message_data('ja');
    $message_data->{message}{'id.regexp'} = q{使用できる文字は半角英数字及び'_', '-'です。};
    $message_data->{message}{'password.regexp'} =
      '使用できる文字は半角英数字、記号で、数字を必ず1文字以上含めて下さい。';
    HirakataPapark::Validator::MessageData->new( $message_data->to_hash );
  }

  sub create_english_data($self) {
    my $message_data = $self->default_data->message_data('en');
    $message_data->{message}{'id.regexp'} = q{You can use alphanumeric and '_', '-'.};
    $message_data->{message}{'password.regexp'} =
      q{You can use alphanumeric and symbols and be sure to include one or more numbers.};
    HirakataPapark::Validator::MessageData->new( $message_data->to_hash );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

