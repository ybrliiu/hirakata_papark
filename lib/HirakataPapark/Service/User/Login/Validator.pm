package HirakataPapark::Service::User::Login::Validator {

  use Mouse;
  use HirakataPapark;
  use Either;

  with 'HirakataPapark::Service::Role::Validator';

  has 'maybe_user' => ( is => 'ro', isa => 'Option::Option', required => 1 );

  sub validate($self) {
    my $v = $self->validator;
    $self->maybe_user->match(
      Some => sub ($user) {
        $v->check(
          id       => ['NOT_NULL'],
          password => ['NOT_NULL', [EQUAL => $user->password]],
        );
        $v->has_error ? left $v : right $user;
      },
      None => sub {
        $v->set_error(id => 'not_found');
        left $v;
      },
    );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

