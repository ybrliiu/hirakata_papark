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

  with 'HirakataPapark::Model::Role::DB';

  sub _build_select_columns_maker($self) {
    HirakataPapark::Model::Role::DB::ForeignLanguage::SelectColumnsMaker->new(
      schema               => $self->db->schema,
      table_name           => $self->TABLE,
      orig_lang_table_name => $self->ORIG_LANG_TABLE,
    );
  }
  
  sub select($self, @args) {
  }

  sub join_and_select($self, $column, $bind) {
    my $sql = << "EOS";
SELECT @{[ $self->select_columns_maker->output_for_sql ]} FROM @{[ $self->ORIG_LANG_TABLE ]}
  INNER JOIN @{[ $self->TABLE ]}
  ON @{[ $self->select_columns_maker->output_relate_fields_for_sql ]}
  WHERE ${column} = ?
EOS
    $self->db->select_by_sql($sql, [$bind], {table_name => $self->TABLE});
  }

  around get_rows_all => sub ($orig, $self) {
  };

  sub get_orig_rows_all($self) {
    $self->result_class->new([ $self->db->select($self->TABLE => {})->all ]);
  }

}

1;

