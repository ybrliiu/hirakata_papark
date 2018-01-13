package HirakataPapark::Service::User::RegistrationFromTwitter::Validator {

  use Mouse;
  use HirakataPapark;
  use Either;

  has 'users' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Users::Users',
    required => 1,
  );

  with 'HirakataPapark::Validator::Validator';

  sub validate($self) {
    $self->check(
      id         => ['NOT_NULL'],
      name       => ['NOT_NULL'],
      twitter_id => ['NOT_NULL'],
    );
    for my $key (qw/ id name twitter_id /) {
      my $method_name = "get_row_by_${key}";
      $self->users->$method_name( $self->param($key)->get_or_else('') )->foreach(sub ($user) {
        $self->set_error($key => 'already_exist');
      });
    }
    $self->has_error ? left $self->core : right $self->core;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

