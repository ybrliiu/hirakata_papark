package HirakataPapark::Model::Users::ParkEditHistories::Role::OneToMany {

  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Model::Result;

  with 'HirakataPapark::Model::Users::ParkEditHistories::Role::ParkEditHistories';

  sub tables_meta;
  has 'tables_meta' => (
    is      => 'ro',
    does    => 'HirakataPapark::Model::Users::ParkEditHistories::Role::OneToMany::TablesMeta',
    handles => [qw(
      BODY_TABLE_NAME
      DEFAULT_LANG_TABLE_NAME
      get_foreign_lang_table_name_by_lang
    )],
    lazy    => 1,
    builder => '_build_tables_meta',
  );

  # methods
  requires qw( _build_tables_meta );

}

1;
