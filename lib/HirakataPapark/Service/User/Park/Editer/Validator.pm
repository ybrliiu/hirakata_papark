package HirakataPapark::Service::User::Park::Editer::Validator {

  use Mouse;
  use HirakataPapark;
  use Either;
  use aliased 'HirakataPapark::Service::User::Park::Editer::MessageData';
  use namespace::autoclean;

  with 'HirakataPapark::Validator::Validator';

=head1
      lang_records => $LangRecords->new(
        ja => $LangRecord->new(
          name    => 'ぞのはなこうえん',
          address => 'A市B町',
          explain => '',
        ),
        en => $LangRecord->new(
          name    => 'Zonohana Park',
          address => 'B town A city',
          explain => '',
        ),
      ),
=cut

  around _build_validator => sub ($orig, $self) {
    my $core = $self->$orig();
    $core->load_constraints($_) for qw( Japanese Number );
    $core;
  };

  sub validate($self) {
    $self->check(
      ( map { $_ => ['NOT_NULL', 'INT'] } qw( park_id x y area ) ),
      zipcode            => ['NOT_NULL', 'JZIP'],
      is_evacuation_area => ['NOT_NULL', [BETWEEN => qw( 0 1 )]],
    );
    $self->has_error ? left $self->core : right $self->core;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

