package HirakataPapark::Service::User::ParkTagger::Validator {

  use Mouse;
  use HirakataPapark;
  use Either;

  use constant {
    MIN_TAG_NAME_LEN => 2,
    MAX_TAG_NAME_LEN => 15,
  };

  with 'HirakataPapark::Service::Role::Validator';

  sub validate($self) {
    my $v = $self->validator;
    $v->check(
      park_id  => ['NOT_NULL', 'INT'],
      tag_name => ['NOT_NULL', [LENGTH => (MIN_TAG_NAME_LEN, MAX_TAG_NAME_LEN)]],
    );
    $v->has_error ? left $v : right $self->params;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

