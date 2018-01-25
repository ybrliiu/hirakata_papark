package HirakataPapark::Service::User::Park::Editer::Validator {

  use Mouse;
  use HirakataPapark;
  use Either;

  with 'HirakataPapark::Validator::Validator';

  around _build_core => sub ($orig, $self) {
    my $core = $self->$orig();
    $core->load_constraints($_) for qw( Japanese Number );
    $core;
  };

  sub validate($self) {
    $self->check(
      ( map { $_ => ['NOT_NULL'] } qw( park_id x y area ) ),
      zipcode            => ['NOT_NULL', 'JZIP'],
      is_evacuation_area => ['NOT_NULL', [BETWEEN => qw( 0 1 )]],
    );
    $self->has_error ? left $self->core : right $self->core;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

