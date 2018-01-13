package HirakataPapark::Service::User::Park::Editer::LangRecordValidator {

  use Mouse;
  use HirakataPapark;
  use Either;

  with 'HirakataPapark::Validator::Validator';

  use constant {
    MIN_NAME_LEN    => 3,
    MAX_NAME_LEN    => 30,
    MIN_ADDRESS_LEN => 7,
    MAX_ADDRESS_LEN => 40,
    MIN_EXPLAIN_LEN => 0,
    MAX_EXPLAIN_LEN => 200,
  };

  sub validate($self) {
    $self->check(
      name    => ['NOT_NULL', [LENGTH => (MIN_NAME_LEN, MAX_NAME_LEN)]],
      address => ['NOT_NULL', [LENGTH => (MIN_ADDRESS_LEN, MAX_ADDRESS_LEN)]],
      explain => [[LENGTH => (MIN_EXPLAIN_LEN, MAX_EXPLAIN_LEN)]],
    );
    $self->has_error ? left $self->core : right $self->core;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

