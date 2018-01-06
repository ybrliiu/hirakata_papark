package HirakataPapark::Model::Users::ParkEditHistories::Base {

  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Model::Result;

  has 'db' => (
    is       => 'ro',
    isa      => 'HirakataPapark::DB',
    required => 1,
  );

  has 'tables' => (
    is      => 'ro',
    does    => 'HirakataPapark::Model::Users::ParkEditHistories::Role::Tables',
    handles => [qw(
      BODY_TABLE_NAME
      FOREIGN_LANGS_TABLE_NAMES
      body_table
      select_columns_makers
    )],
    lazy    => 1,
    builder => '_build_tables',
  );

  # methods
  requires qw(
    _build_tables
    add_history
    get_histories_by_park_id
    get_histories_by_user_seacret_id
  );

  sub create_result($self, $contents) {
    HirakataPapark::Model::Result->new(contents => $contents);
  }

}

1;
