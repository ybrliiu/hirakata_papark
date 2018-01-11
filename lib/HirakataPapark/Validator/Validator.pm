package HirakataPapark::Validator::Validator {

  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Validator::Core;
  use HirakataPapark::Validator::Params;

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

  has 'core' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Validator::Core',
    lazy     => 1,
    handles  => [qw(
      check
      is_error
      set_error
      has_error
      errors_and_messages
      get_error_message
      get_error_messages
    )],
    builder  => '_build_core',
  );

  # methods
  requires qw( validate );

  sub _build_core($self) {
    # pass the hash value for validator constructor is EXPERIMENTAL.
    my $core = HirakataPapark::Validator::Core->new($self->params->to_hash);
    $core->set_message_data($self->message_data);
    $core;
  }

}

1;

