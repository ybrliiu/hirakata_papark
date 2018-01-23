package HirakataPapark::Model::Role::DB::ForeignLang::RelatedToPark {

  use Mouse::Role;
  use HirakataPapark;
  use namespace::autoclean;

  with qw(
    HirakataPapark::Model::Role::DB::ForeignLang
    HirakataPapark::Model::Role::DB::RelatedToPark
  );

  sub create_distinct_select($self) {
    my $select      = $self->db->query_builder->new_select(distinct => 1);
    my $tables_meta = $self->tables_meta;
    my $foreign_lang_table = $tables_meta->foreign_lang_table;
    $select->add_join(
      $tables_meta->body_table->name => {
        type      => 'inner',
        table     => $foreign_lang_table->name,
        condition => $foreign_lang_table->join_condition,
      }
    );
    $select;
  }

  sub get_name_list($self) {
    my $select = $self->create_distinct_select;
    $select->add_select($self->FOREIGN_LANG_TABLE_NAME . '.name');
    my $dbh = $self->db->dbh;
    my $result = $dbh->selectall_arrayref($select->as_sql, undef);
    [ map { @$_ } @$result ];
  }

}

1;
