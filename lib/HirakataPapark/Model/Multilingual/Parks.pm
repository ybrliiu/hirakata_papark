package HirakataPapark::Model::Multilingual::Parks {

  use Mouse;
  use HirakataPapark;
  use Option;
  use Smart::Args qw( args_pos );
  use aliased 'HirakataPapark::Model::Multilingual::Parks::MultilingualRowBuilder';
  use namespace::autoclean;

  use constant BODY_TABLE_NAME => 'park';

  sub foreign_lang_table_name($class) {
    sub ($lang) { "${lang}_park" };
  }

  with qw(
    HirakataPapark::Model::Role::DB
    HirakataPapark::Model::Role::DB::Multilingual::HasOne
  );

  sub get_multilingual_row_by_park_id($self, $lang, $park_id) {
    my $select = $self->db->query_builder->new_select;
    for my $table ($self->join_tables->@*) {
      $select->add_join($table->name => {
          type      => 'inner',
          table     => $self->body_table->name,
          condition => $table->join_condition,
      });
    }
    for my $table ($self->tables->@*) {
      for my $column_name ($table->select_columns->@*) {
        $select->add_select($column_name);
      }
    }
    $select->add_where($self->body_table->name . '.id' => $park_id);
    my $dbh = $self->db->dbh;
    my $sth = $dbh->prepare($select->as_sql);
    $sth->execute($select->bind);
    my $rows = $sth->fetchall_arrayref;
    option( $rows->[0] )->map(sub ($row) {
      my $builder = MultilingualRowBuilder->new({
        sth         => $sth,
        row         => $rows->[0],
        lang        => $lang,
        tables_meta => $self->tables_meta,
      });
      $builder->build;
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__
