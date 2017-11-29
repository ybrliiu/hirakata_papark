package HirakataPapark::Model::Parks::EnglishEquipments {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );

  use constant {
    TABLE           => 'english_park_equipment',
    ORIG_LANG_TABLE => 'park_equipment',
  };

  with qw(
    HirakataPapark::Model::Role::DB::ForeignLanguage
    HirakataPapark::Model::Role::DB::ForeignLanguage::RelatedToPark
    HirakataPapark::Model::Role::DB::Parks::Equipments
  );

  sub add_row {
    args my $self, my $id => 'Int',
      my $park_id => 'Int',
      my $name    => 'Str',
      my $comment => { isa => 'Str', default => '' };

    $self->insert({
      id      => $id,
      park_id => $park_id,
      name    => $name,
      comment => $comment,
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;
