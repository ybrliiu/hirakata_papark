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

  around _get_stared_rows_by_user_seacret_id_sql => sub ($orig, $self, $user_seacret_id) {
    my $select = $self->$orig($user_seacret_id);
    $select->add_join(ORIG_LANG_TABLE, => {
      type      => 'inner',
      table     => TABLE,
      condition => "@{[ ORIG_LANG_TABLE ]}.id = @{[ TABLE ]}.id",
    });
    $select;
  };

  around get_stared_rows_by_user_seacret_id => sub ($orig, $self, $user_seacret_id) {
    my $select = $self->_get_stared_rows_by_user_seacret_id_sql($user_seacret_id);
    $self->db->select_by_sql($select->as_sql, [$select->bind], { table => TABLE });
  };

  __PACKAGE__->meta->make_immutable;

}

1;

