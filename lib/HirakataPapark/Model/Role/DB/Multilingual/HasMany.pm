package HirakataPapark::Model::Role::DB::Multilingual::HasMany {

  use Mouse::Role;
  use HirakataPapark;
  use aliased
    'HirakataPapark::Model::Role::DB::TablesMeta::Multilingual::HasMany' => 'TablesMeta';
  use namespace::autoclean;

  # constants
  requires qw( BODY_TABLE_NAME DEFAULT_LANG_TABLE_NAME );

  # func
  requires qw( foreign_lang_table_name );

  # attributes
  requires qw( db );

  sub tables_meta;
  has 'tables_meta' => (
    is      => 'ro',
    isa     => TablesMeta,
    handles => [qw(
      get_foreign_lang_table_by_lang
      body_table
      default_lang_table
      foreign_lang_tables
      tables
      join_tables
    )],
    lazy    => 1,
    builder => '_build_tables_meta',
  );

  sub _build_tables_meta($self) {
    TablesMeta->new({
      schema                  => $self->db->schema,
      body_table_name         => $self->BODY_TABLE_NAME,
      default_lang_table_name => $self->DEFAULT_LANG_TABLE_NAME,
      foreign_lang_table_name => $self->foreign_lang_table_name,
    });
  }

}

1;
