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
    default => sub ($self) {
      HirakataPapark::Validator::DefaultMessageData->instance;
    },
  );

  sub create_japanese_data($self) {
    state $data = HirakataPapark::Validator::MessageData->new({
      $self->default_data->create_japanese_data->%*,
      message => { 'id.not_found' => q{そのIDのユーザーは存在しません。} },
    });
  }

  sub create_english_data($self) {
    state $data = HirakataPapark::Validator::MessageData->new({
      $self->default_data->create_english_data->%*,
      message => { 'id.not_found' => q{No such user.} },
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

