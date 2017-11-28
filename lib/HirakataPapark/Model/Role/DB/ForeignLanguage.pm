package HirakataPapark::Model::Role::DB::ForeignLanguage {

  use Mouse::Role;
  use HirakataPapark;

  use HirakataPapark::Model::Role::DB::ForeignLanguage::SelectColumnsMaker;

  requires qw( ORIG_LANG_TABLE );

  has 'select_columns_maker' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Role::DB::ForeignLanguage::SelectColumnsMaker',
    lazy    => 1,
    builder => '_build_select_columns_maker',
  );

  with 'HirakataPapark::Model::Role::DB' => {
    -alias   => { select => 'select_orig' },
    -exclude => 'select',
  };

  sub _build_select_columns_maker($self) {
    HirakataPapark::Model::Role::DB::ForeignLanguage::SelectColumnsMaker->new(
      schema               => $self->db->schema,
      table_name           => $self->TABLE,
      orig_lang_table_name => $self->ORIG_LANG_TABLE,
    );
  }

  sub select($self, $where, $opt = {}) {

    # SQL::Maker::Select
    my $select   = $self->db->query_builder->new_select;
    my $sc_maker = $self->select_columns_maker;

    for my $column ($sc_maker->select_columns->@*) {
      $select->add_select($column);
    }

    $select->add_join(
      $self->ORIG_LANG_TABLE => {
        type      => 'inner',
        table     => $self->TABLE,
        condition => $self->select_columns_maker->join_condition,
      }
    );

    while (my ($col, $val) = each %$where) {
      $select->add_where($col => $val);
    }

    _add_option($select, $opt, $_) for qw/ limit offset prefix /;
    _add_options($select, $opt, $_) for qw/ order_by group_by /;

    $self->db->select_by_sql($select->as_sql, [$select->bind], { %$opt, table_name => $self->TABLE });
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

=head1
  # 本当はこうしたい
  # が、エラーになってしまう..
  # SQL::Maker か Aniki のバグの可能性あり?
  # join句あたりが壊れるっぽい

  sub select($self, $where, $opt = {}) {
    my $sc_maker = $self->select_columns_maker;
    $self->db->select(
      $self->TABLE,
      $where,
      {
        %$opt,
        columns => $sc_maker->select_columns,
        joins => [
          $self->TABLE => {
            type      => 'inner',
            table     => $self->ORIG_LANG_TABLE,
            condition => $self->select_columns_maker->output_relate_fields_for_sql,
          }
        ],
      }
    );
  }
=cut

  sub get_orig_rows_all($self) {
    $self->result_class->new([ $self->db->select($self->TABLE => {})->all ]);
  }

}

1;

