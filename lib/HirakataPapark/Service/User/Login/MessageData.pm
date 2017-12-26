package HirakataPapark::Service::User::Login::MessageData {

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
    $message_data->{message}{'id.not_found'} = 'そのIDのユーザーは存在しません。';
    HirakataPapark::Validator::MessageData->new( $message_data->to_hash );
  }

  sub create_english_data($self) {
    my $message_data = $self->default_data->message_data('en');
    $message_data->{message}{'id.not_found'} = 'No such user.';
    HirakataPapark::Validator::MessageData->new( $message_data->to_hash );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

