package HirakataPapark::Service::User::Regist::Validator {

  use Mouse;
  use HirakataPapark;
  use Either;
  use HirakataPapark::Validator;
  use HirakataPapark::Service::Role::Validator;

  use constant {
    MIN_NAME_LEN     => 1,
    MAX_NAME_LEN     => 20,
    MIN_ID_LEN       => 4,
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

  with 'HirakataPapark::Service::Role::Validator';

  sub validate($self) {
    my $v = $self->validator;
    $v->check(
      name        => ['NOT_NULL', [LENGTH => (MIN_NAME_LEN, MAX_NAME_LEN)]],
      id          => ['NOT_NULL', [LENGTH => (MIN_ID_LEN, MAX_ID_LEN)], [REGEXP => qr/^(.[0-9a-zA-Z_-]*)$/]],
      password    => ['NOT_NULL', [LENGTH => (MIN_ID_LEN, MAX_ID_LEN)], [REGEXP => qr/^(?=.*[0-9])(?=.*[a-zA-Z])/]],
      address     => [[LENGTH => (0, MAX_ADDRESS_LEN)]],
      profile     => [[LENGTH => (0, MAX_PROFILE_LEN)]],
      twitter_id  => [[LENGTH => (0, MAX_PROFILE_LEN)]],
      facebook_id => [[LENGTH => (0, MAX_PROFILE_LEN)]],
    );

    $self->users->get_row_by_id( $self->param('id')->get_or_else('') )->foreach(sub ($user) {
      $v->set_error(id => 'already_exist');
    });

    $self->users->get_row_by_name( $self->param('name')->get_or_else('') )->foreach(sub ($user) {
      $v->set_error(name => 'already_exist');
    });

    $v->has_error ? left $v : right $v;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

