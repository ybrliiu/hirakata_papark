package HirakataPapark::Service::User::AddParkStar::Validator {

  use Mouse;
  use HirakataPapark;
  use Either;

  with 'HirakataPapark::Service::Role::Validator';

  sub validate($self) {
    my $v = $self->validator;
    $v->check(park_id => ['NOT_NULL', 'INT']);
    $v->has_error ? left $v : right $self->param('park_id')->get;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

