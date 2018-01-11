package HirakataPapark::Service::User::Regist::Validator {

  use Mouse;
  use HirakataPapark;
  use Either;

  use constant {
    MIN_NAME_LEN     => 1,
    MAX_NAME_LEN     => 20,
    MIN_ID_LEN       => 6,
    MAX_ID_LEN       => 20,
    MIN_PASSWORD_LEN => 10,
    MAX_PASSWORD_LEN => 40,
    MAX_ADDRESS_LEN  => 40,
    MAX_PROFILE_LEN  => 400,
  };

  has 'users' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Users::Users',
    required => 1,
  );

  with 'HirakataPapark::Validator::Validator';

  sub validate($self) {
    $self->check(
      name => ['NOT_NULL', [LENGTH => (MIN_NAME_LEN, MAX_NAME_LEN)]],
      id => [
        'NOT_NULL',
        [LENGTH => (MIN_ID_LEN, MAX_ID_LEN)],
        [REGEXP => qr/^(.[0-9a-zA-Z_-]*)$/],
      ],
      password => [
        'NOT_NULL',
        [LENGTH => (MIN_ID_LEN, MAX_ID_LEN)],
        [REGEXP => qr/^(?=.*[0-9])(.[!-~]*)$/],
      ],
      address => [[LENGTH => (0, MAX_ADDRESS_LEN)]],
      profile => [[LENGTH => (0, MAX_PROFILE_LEN)]],
    );

    $self->users->get_row_by_id( $self->param('id')->get_or_else('') )->foreach(sub ($user) {
      $self->set_error(id => 'already_exist');
    });

    $self->users->get_row_by_name( $self->param('name')->get_or_else('') )->foreach(sub ($user) {
      $self->set_error(name => 'already_exist');
    });

    $self->has_error ? left $self->core : right $self->core;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

