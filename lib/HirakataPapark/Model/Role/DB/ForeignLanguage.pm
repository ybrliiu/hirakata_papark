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

    # SQL::Maker::Condition
    my $condition = $self->db->query_builder->new_condition;
    my @wheres = ref $where eq 'HASH' ? %$where : @$where;
    my @binds;
    while (my ($col, $val) = splice @wheres, 0, 2) {
      push @binds, $val;
      $condition->add($col => $val);
    }

    my $sql = << "EOS";
SELECT @{[ $self->select_columns_maker->output_for_sql ]}
  FROM @{[ $self->ORIG_LANG_TABLE ]}
  INNER JOIN @{[ $self->TABLE ]}
  ON @{[ $self->select_columns_maker->output_relate_fields_for_sql ]}
  WHERE @{[ $condition->as_sql ]}
EOS

    $self->db->select_by_sql($sql, \@binds, { %$opt, table_name => $self->TABLE });
  }

  sub get_orig_rows_all($self) {
    $self->result_class->new([ $self->db->select($self->TABLE => {})->all ]);
  }

}

1;

