package HirakataPapark::Service::Role::Validator {

  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Validator;
  use HirakataPapark::Validator::Params;

  # methods
  requires qw( validate );

  has 'message_data' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Validator::MessageData',
    required => 1,
  );

  has 'params' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Validator::Params',
    handles  => ['param'],
    required => 1,
  );

  has 'validator' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Validator',
    lazy     => 1,
    builder  => '_build_validator',
  );

  sub _build_validator($self) {
    # pass the hash value for validator constructor is EXPERIMENTAL.
    my $validator = HirakataPapark::Validator->new($self->params->to_hash);
    $validator->set_message_data($self->message_data);
    $validator;
  }

}

1;

