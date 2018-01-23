package HirakataPapark::Model::Parks::EnglishEquipments {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );

  use constant {
    LANG                    => 'en',
    BODY_TABLE_NAME         => 'park_equipment',
    FOREIGN_LANG_TABLE_NAME => 'english_park_equipment',
  };

  with qw(
    HirakataPapark::Model::Role::DB::ForeignLang::RelatedToPark
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

  sub get_equipment_list($self) {
    $self->get_name_list;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
