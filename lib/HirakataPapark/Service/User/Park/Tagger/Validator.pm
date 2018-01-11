package HirakataPapark::Service::User::Park::Tagger::Validator {

  use Mouse;
  use HirakataPapark;
  use Either;

  use constant {
    MIN_TAG_NAME_LEN => 2,
    MAX_TAG_NAME_LEN => 15,
  };

  with 'HirakataPapark::Validator::Validator';

  sub validate($self) {
    $self->check(
      park_id  => ['NOT_NULL', 'INT'],
      tag_name => ['NOT_NULL', [LENGTH => (MIN_TAG_NAME_LEN, MAX_TAG_NAME_LEN)]],
    );
    $self->has_error ? left $self->core : right $self->params;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

