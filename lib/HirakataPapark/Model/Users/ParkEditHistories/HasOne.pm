package HirakataPapark::Model::Users::ParkEditHistories::HasOne {

  use Mouse::Role;
  use HirakataPapark;

  with 'HirakataPapark::Model::Users::ParkEditHistories::ParkEditHistories';

  my $MetaTables =
    'HirakataPapark::Model::Users::ParkEditHistories::MetaTables::HasOne::MetaTables';
  sub meta_tables;
  has 'meta_tables' => (
    is      => 'ro',
    does    => $MetaTables,
    handles => [qw(
      BODY_TABLE_NAME
      get_foreign_lang_table_by_lang
      body_table
      foreign_lang_tables
      tables
      join_tables
    )],
    lazy    => 1,
    builder => '_build_meta_tables',
  );

  # methods
  requires qw( _build_meta_tables );

}

1;
