package HirakataPapark::Service::User::RegistrationFromTwitter::Validator {

  use Mouse;
  use HirakataPapark;
  use Either;
  use HirakataPapark::Validator;

  has 'users' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Users::Users',
    required => 1,
  );

  with 'HirakataPapark::Service::Role::Validator';

  sub validate($self) {
    my $v = $self->validator;
    $v->check(
      id         => ['NOT_NULL'],
      name       => ['NOT_NULL'],
      twitter_id => ['NOT_NULL'],
    );
    for my $key (qw/ id name twitter_id /) {
      my $method_name = "get_row_by_${key}";
      $self->users->$method_name( $self->param($key)->get_or_else('') )->foreach(sub ($user) {
        $v->set_error($key => 'already_exist');
      });
    }
    $v->has_error ? left $v : right $v;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

