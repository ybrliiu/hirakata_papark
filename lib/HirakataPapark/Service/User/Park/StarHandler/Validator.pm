package HirakataPapark::Service::User::Park::StarHandler::Validator {

  use Mouse;
  use HirakataPapark;
  use Either;

  with 'HirakataPapark::Validator::Validator';

  sub validate($self) {
    $self->check(park_id => ['NOT_NULL', 'INT']);
    $self->has_error ? left $self->core : right $self->param('park_id')->get;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

