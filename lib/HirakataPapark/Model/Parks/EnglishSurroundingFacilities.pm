package HirakataPapark::Model::Parks::EnglishSurroundingFacilities {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );

  use constant {
    LANG                    => 'en',
    BODY_TABLE_NAME         => 'park_surrounding_facility',
    FOREIGN_LANG_TABLE_NAME => 'english_park_surrounding_facility',
  };

  with qw(
    HirakataPapark::Model::Role::DB::ForeignLang::RelatedToPark
    HirakataPapark::Model::Role::DB::Parks::SurroundingFacilities
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

  sub get_names_by_park_id($self, $park_id) {
    my $select = $self->create_distinct_select;
    $select->add_select($self->FOREIGN_LANG_TABLE_NAME . '.name');
    $select->add_where($self->FOREIGN_LANG_TABLE_NAME . '.park_id' => $park_id);
    my $dbh = $self->db->dbh;
    my $result = $dbh->selectall_arrayref($select->as_sql, undef, $park_id);
    [ map { @$_ } @$result ];
  }

  sub get_surrounding_facility_list($self) {
    $self->get_name_list;
  }

  __PACKAGE__->meta->make_immutable;

}

1;


