package HirakataPapark::Model::Parks::EnglishSurroundingFacilities {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );

  use constant {
    TABLE           => 'english_park_surrounding_facility',
    ORIG_LANG_TABLE => 'park_surrounding_facility',
  };

  with qw(
    HirakataPapark::Model::Role::DB::ForeignLanguage
    HirakataPapark::Model::Role::DB::ForeignLanguage::RelatedToPark
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
    my $sc_maker = $self->select_columns_maker;
    my $sql = << "EOS";
SELECT DISTINCT "@{[ $self->TABLE ]}"."name"
  FROM "@{[ $self->ORIG_LANG_TABLE ]}"
  INNER JOIN "@{[ $self->TABLE ]}"
  ON @{[ $sc_maker->output_join_condition_for_sql ]}
  WHERE "@{[ $self->TABLE ]}"."park_id" = ?
EOS
    my $dbh = $self->db->dbh;
    my $result = $dbh->selectall_arrayref($sql, undef, $park_id);
    [ map { @$_ } @$result ];
  }

  sub get_surrounding_facility_list($self) {
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


