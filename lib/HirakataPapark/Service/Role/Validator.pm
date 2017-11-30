package HirakataPapark::Service::Role::Validator {

  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Validator;

  # methods
  requires qw( validate );

  has 'message_data' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Validator::MessageData',
    required => 1,
  );

  has 'validator' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Validator',
    lazy     => 1,
    builder  => '_build_validator',
  );

  sub check_params($self) {
    my @attributes = $self->get_check_param_attributes;
    +{ map { $_ => $self->$_ } map { $_->name } @attributes };
  }

  sub _build_validator($self) {
    # pass the hash value for validator constructor is EXPERIMENTAL.
    my $validator = HirakataPapark::Validator->new($self->check_params);
    $validator->set_message_data($self->message_data);
    $validator;
  }

  sub get_check_param_attributes {
    my $class = ref $_[0] || $_[0];
    state $cache = {};
    return $cache->{$class}->@* if exists $cache->{$class};
    my @attributes = grep {
      $_->isa('HirakataPapark::Service::Role::Validator::Attribute::CheckParam')
    } $class->meta->get_all_attributes;
    $cache->{$class} = \@attributes;
    @attributes;
  }

}

1;

package Mouse::Meta::Attribute::Custom::CheckParam {
  sub register_implementation() { 'HirakataPapark::Service::Role::Validator::Attribute::CheckParam' }
}

package HirakataPapark::Service::Role::Validator::Attribute::CheckParam {
  use Mouse;
  extends 'Mouse::Meta::Attribute';
}

1;

