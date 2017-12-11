package HirakataPapark::Model::Parks::EnglishPlants {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );

  use constant {
    TABLE           => 'english_park_plants',
    ORIG_LANG_TABLE => 'park_plants',
  };

  with qw(
    HirakataPapark::Model::Role::DB::ForeignLanguage
    HirakataPapark::Model::Role::DB::ForeignLanguage::RelatedToPark
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
    my $sc_maker = $self->select_columns_maker;
    $columns = [ map { qq{"@{[ $self->TABLE ]}"."$_"} } @$columns ];
    my $sql = << "EOS";
SELECT DISTINCT @{[ join ', ', @$columns ]}
  FROM "@{[ $self->ORIG_LANG_TABLE ]}"
  INNER JOIN "@{[ $self->TABLE ]}"
  ON @{[ $sc_maker->output_join_condition_for_sql ]}
EOS
    my $rows = $self->db->select_by_sql($sql, [], {});
    $self->result_class->new([ $rows->all ]);
  }

  sub get_categories($self) {
    my $sc_maker = $self->select_columns_maker;
    my $sql = << "EOS";
SELECT DISTINCT "@{[ $self->TABLE ]}"."category"
  FROM "@{[ $self->ORIG_LANG_TABLE ]}"
  INNER JOIN "@{[ $self->TABLE ]}"
  ON @{[ $sc_maker->output_join_condition_for_sql ]}
EOS
    my $dbh = $self->db->dbh;
    my $result = $dbh->selectall_arrayref($sql, undef);
    [ map { @$_ } @$result ];
  }

  sub get_categories_by_park_id($self, $park_id) {
    my $sc_maker = $self->select_columns_maker;
    my $sql = << "EOS";
SELECT DISTINCT "@{[ $self->TABLE ]}"."category"
  FROM "@{[ $self->ORIG_LANG_TABLE ]}"
  INNER JOIN "@{[ $self->TABLE ]}"
  ON @{[ $sc_maker->output_join_condition_for_sql ]}
  WHERE "@{[ $self->TABLE ]}"."park_id" = ?
EOS
    my $dbh = $self->db->dbh;
    my $result = $dbh->selectall_arrayref($sql, undef, $park_id);
    [ map { @$_ } @$result ];
  }

  sub get_plants_list($self) {
    my $sc_maker = $self->select_columns_maker;
    my $sql = << "EOS";
SELECT DISTINCT "@{[ $self->TABLE ]}"."name"
  FROM "@{[ $self->ORIG_LANG_TABLE ]}"
  INNER JOIN "@{[ $self->TABLE ]}"
  ON @{[ $sc_maker->output_join_condition_for_sql ]}
EOS
    my $dbh = $self->db->dbh;
    my $result = $dbh->selectall_arrayref($sql, undef);
    [ map { @$_ } @$result ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

