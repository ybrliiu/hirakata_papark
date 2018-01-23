package HirakataPapark::Model::Parks::EnglishPlants {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );

  use constant {
    LANG                    => 'en',
    BODY_TABLE_NAME         => 'park_plants',
    FOREIGN_LANG_TABLE_NAME => 'english_park_plants',
  };

  with qw(
    HirakataPapark::Model::Role::DB::ForeignLang::RelatedToPark
    HirakataPapark::Model::Role::DB::Parks::Plants
  );

  sub add_row {
    args my $self, my $id => 'Int',
      my $park_id  => 'Int',
      my $name     => 'Str',
      my $category => 'Str',
      my $comment  => { isa => 'Str', default => '' };

    $self->insert({
      id       => $id,
      park_id  => $park_id,
      name     => $name,
      category => $category,
      comment  => $comment,
    });
  }

  sub get_all_distinct_rows($self, $columns) {
    my $select = $self->create_distinct_select;
    for my $column (@$columns) {
      $select->add_select($self->FOREIGN_LANG_TABLE_NAME . ".$column");
    }
    my $rows = $self->db->select_by_sql( $select->as_sql, [], {} );
    $self->create_result($rows->rows);
  }

  sub get_categories($self) {
    my $select = $self->create_distinct_select;
    $select->add_select($self->FOREIGN_LANG_TABLE_NAME . '.category');
    my $dbh = $self->db->dbh;
    my $result = $dbh->selectall_arrayref($select->as_sql, undef);
    [ map { @$_ } @$result ];
  }

  sub get_categories_by_park_id($self, $park_id) {
    my $select = $self->create_distinct_select;
    $select->add_select($self->FOREIGN_LANG_TABLE_NAME . '.category');
    $select->add_where($self->FOREIGN_LANG_TABLE_NAME . '.park_id' => $park_id);
    my $dbh = $self->db->dbh;
    my $result = $dbh->selectall_arrayref($select->as_sql, undef, $select->bind);
    [ map { @$_ } @$result ];
  }

  sub get_plants_list($self) {
    $self->get_name_list;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

