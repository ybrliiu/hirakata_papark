package HirakataPapark::Model::Parks::EnglishParks {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );
  
  use constant {
    LANG                    => 'en',
    BODY_TABLE_NAME         => 'park',
    FOREIGN_LANG_TABLE_NAME => 'english_park',
  };

  with qw(
    HirakataPapark::Model::Role::DB::ForeignLang
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
    $select->add_join(BODY_TABLE_NAME, => {
      type      => 'inner',
      table     => FOREIGN_LANG_TABLE_NAME,
      condition => "@{[ FOREIGN_LANG_TABLE_NAME ]}.id = @{[ BODY_TABLE_NAME ]}.id",
    });
    $select;
  };

  around get_stared_rows_by_user_seacret_id => sub ($orig, $self, $user_seacret_id) {
    my $select = $self->_get_stared_rows_by_user_seacret_id_sql($user_seacret_id);
    $self->db->select_by_sql(
      $select->as_sql,
      [$select->bind],
      { table => BODY_TABLE_NAME }
    );
  };

  __PACKAGE__->meta->make_immutable;

}

1;

