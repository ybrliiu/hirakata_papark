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

  has 'name'        => ( is => 'ro', isa => 'Str', metaclass => 'CheckParam', required => 1 );
  has 'id'          => ( is => 'ro', isa => 'Str', metaclass => 'CheckParam', required => 1 );
  has 'password'    => ( is => 'ro', isa => 'Str', metaclass => 'CheckParam', required => 1 );
  has 'address'     => ( is => 'ro', isa => 'Str', metaclass => 'CheckParam', default => '' );
  has 'profile'     => ( is => 'ro', isa => 'Str', metaclass => 'CheckParam', default => '' );
  has 'twitter_id'  => ( is => 'ro', isa => 'Str', metaclass => 'CheckParam', default => '' );
  has 'facebook_id' => ( is => 'ro', isa => 'Str', metaclass => 'CheckParam', default => '' );

  has 'users' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Users',
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

    $self->users->get_row_by_id($self->id)->foreach(sub ($user) {
      $v->set_error(id => 'already_exists');
    });

    $self->users->get_row_by_name($self->name)->foreach(sub ($user) {
      $v->set_error(name => 'already_exists');
    });

    $v->has_error ? left $v : right $v;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

