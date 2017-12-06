package HirakataPapark::Model::Parks::EnglishParks {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );
  
  use constant {
    TABLE           => 'english_park',
    ORIG_LANG_TABLE => 'park',
  };

  with qw(
    HirakataPapark::Model::Role::DB::ForeignLanguage
    HirakataPapark::Model::Role::DB::Parks::Parks
  );

  sub add_row {
    args my $self, my $id => 'Str',
      my $name    => 'Str',
      my $address => 'Str',
      my $explain => { isa => 'Str', default => '' };

    $self->insert({
      id      => $id,
      name    => $name,
      address => $address,
      explain => $explain,
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

