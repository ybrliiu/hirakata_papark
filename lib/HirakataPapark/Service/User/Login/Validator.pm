package HirakataPapark::Service::User::Login::Validator {

  use Mouse;
  use HirakataPapark;
  use Either;

  with 'HirakataPapark::Validator::Validator';

  has 'maybe_user' => ( is => 'ro', isa => 'Option::Option', required => 1 );

  sub validate($self) {
    $self->maybe_user->match(
      Some => sub ($user) {
        $self->check(
          id       => ['NOT_NULL'],
          password => ['NOT_NULL', [EQUAL => $user->password]],
        );
        $self->set_error(login_method => 'invalid') unless $user->is_from_site;
        $self->has_error ? left $self->core : right $user;
      },
      None => sub {
        $self->set_error(id => 'not_found');
        left $self->core;
      },
    );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

