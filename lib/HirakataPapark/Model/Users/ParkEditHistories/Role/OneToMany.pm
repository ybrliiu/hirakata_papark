package HirakataPapark::Model::Users::ParkEditHistories::Role::OneToMany {

  use Mouse::Role;
  use HirakataPapark;

  with 'HirakataPapark::Model::Users::ParkEditHistories::Role::ParkEditHistories';

  my $MetaTables =
    'HirakataPapark::Model::Users::ParkEditHistories::Role::OneToMany::MetaTables';
  sub meta_tables;
  has 'meta_tables' => (
    is      => 'ro',
    does    => $MetaTables,
    handles => [qw(
      BODY_TABLE_NAME
      DEFAULT_LANG_TABLE_NAME
      get_foreign_lang_table_by_lang
    )],
    lazy    => 1,
    builder => '_build_meta_tables',
  );

  # methods
  requires qw( _build_meta_tables );

}

1;
