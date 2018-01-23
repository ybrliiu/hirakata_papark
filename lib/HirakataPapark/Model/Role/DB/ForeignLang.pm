package HirakataPapark::Model::Role::DB::ForeignLang {

  use Mouse::Role;
  use HirakataPapark;
  use aliased 'HirakataPapark::Model::Role::DB::TablesMeta::ForeignLang' => 'TablesMeta';
  use aliased 'HirakataPapark::Model::Role::DB::ForeignLang::UpdateSetColumnsMaker';
  use namespace::autoclean;

  # constants
  requires qw( LANG BODY_TABLE_NAME FOREIGN_LANG_TABLE_NAME );

  sub HANDLE_TABLE_NAME { $_[0]->FOREIGN_LANG_TABLE_NAME }

  has 'tables_meta' => (
    is      => 'ro',
    isa     => TablesMeta,
    lazy    => 1,
    builder => '_build_tables_meta',
    handles => [qw( body_table )],
  );

  with 'HirakataPapark::Model::Role::DB::RowHandler' => {
    -alias   => { select => 'select_orig' },
    -exclude => 'select',
  };

  sub _build_tables_meta($self) {
    TablesMeta->new({
      lang                    => $self->LANG,
      schema                  => $self->db->schema,
      body_table_name         => $self->BODY_TABLE_NAME,
      foreign_lang_table_name => $self->FOREIGN_LANG_TABLE_NAME,
    });
  }

  sub select($self, $where, $opt = {}) {

    # SQL::Maker::Select
    my $select      = $self->db->query_builder->new_select;
    my $tables_meta = $self->tables_meta;

    my $columns = exists $opt->{columns} ? $opt->{columns} : $tables_meta->select_columns;
    for my $column (@$columns) {
      $select->add_select($column);
    }

    my $foreign_lang_table = $tables_meta->foreign_lang_table;
    $select->add_join(
      $tables_meta->body_table->name => {
        type      => 'inner',
        table     => $foreign_lang_table->name,
        condition => $foreign_lang_table->join_condition,
      }
    );

    while (my ($col, $val) = each %$where) {
      $select->add_where($col => $val);
    }

    _add_option($select, $opt, $_) for qw( limit offset prefix );
    _add_options($select, $opt, $_) for qw( order_by group_by );

    $self->db->select_by_sql(
      $select->as_sql,
      [$select->bind],
      { %$opt, table_name => $self->HANDLE_TABLE_NAME }
    );
  }

  sub _add_option($select, $opt, $opt_type) {
    $select->$opt_type($opt->{$opt_type}) if exists $opt->{$opt_type};
  }

  sub _add_options($select, $opt, $opt_type) {
    my $method_name = "add_${opt_type}";
    if (my $o = $opt->{$opt_type}) {
      if (ref $o eq 'ARRAY') {
        for my $order (@$o) {
          if (ref $order eq 'HASH') {
            # Skinny-ish [{foo => 'DESC'}, {bar => 'ASC'}]
            $select->$method_name(%$order);
          } else {
            # just ['foo DESC', 'bar ASC']
            $select->$method_name(\$order);
          }
        }
      } elsif (ref $o eq 'HASH') {
        # Skinny-ish {foo => 'DESC'}
        $select->$method_name(%$o);
      } else {
        # just 'foo DESC, bar ASC'
        $select->$method_name(\$o);
      }
    }
  }

  sub update($self, $set, $where) {
    my $tables_meta = $self->tables_meta;
    my ($body_table, $foreign_lang_table) =
      ($tables_meta->body_table, $tables_meta->foreign_lang_table);
    my $maker = UpdateSetColumnsMaker->new({
      set                => $set,
      body_table         => $body_table,
      foreign_lang_table => $foreign_lang_table,
    });
    if ($maker->set_of_foreign_lang_table->%*) {
      $self->db->update($foreign_lang_table->name, $maker->set_of_foreign_lang_table, $where);
    }
    if ($maker->set_of_body_table->%*) {
      $self->db->update($body_table->name, $maker->set_of_body_table, $where);
    }
  }

=head1
  # 本当はこうしたいが、join句が壊れてしまう
  # SQL::Maker か Aniki のバグの可能性あり?

  sub select($self, $where, $opt = {}) {
    my $tables_meta = $self->tables_meta;
    $self->db->select(
      $tables_meta->body_table->name,
      $where,
      {
        %$opt,
        columns => $tables_meta->select_columns,
        joins => [
          $tables_meta->body_table->name => {
            type      => 'inner',
            table     => $tables_meta->foreign_lang_table->name,
            condition => $tables_meta->foreign_lang_table->join_condition,
          }
        ],
      }
    );
  }
=cut

  sub get_body_table_rows_all($self) {
    $self->create_result( $self->db->select($self->body_table->name => {})->rows );
  }

}

1;

