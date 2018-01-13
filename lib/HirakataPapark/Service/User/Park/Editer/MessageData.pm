package HirakataPapark::Service::User::Park::Editer::MessageData {

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

  sub _copy_lang_dict_to_messages($self, $message_data) {
    $message_data->{param}{x} = $message_data->{param}{longitude};
    $message_data->{param}{y} = $message_data->{param}{latitude};
    $message_data->{param}{is_evacuation_area} = 
      $message_data->{param}{temp_evacuation_area};
  }

  sub create_japanese_data($self) {
    my $message_data = $self->default_data->message_data('ja');
    $self->_copy_lang_dict_to_messages($message_data);
    $message_data->{function}{jzip} = '郵便番号の書式で入力されていません';
    HirakataPapark::Validator::MessageData->new( $message_data->to_hash );
  }

  sub create_english_data($self) {
    my $message_data = $self->default_data->message_data('en');
    $self->_copy_lang_dict_to_messages($message_data);
    $message_data->{function}{jzip} = 
      'It is not entered in the Japanese postal code format';
    HirakataPapark::Validator::MessageData->new( $message_data->to_hash );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

