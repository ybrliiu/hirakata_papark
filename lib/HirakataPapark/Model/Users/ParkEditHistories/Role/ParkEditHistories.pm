package HirakataPapark::Model::Users::ParkEditHistories::Role::ParkEditHistories {

  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Model::Result;

  has 'db' => (
    is       => 'ro',
    isa      => 'HirakataPapark::DB',
    required => 1,
  );

  # attributes
  requires qw( meta_tables );

  # methods
  requires qw(
    add_history
    get_histories_by_park_id
    get_histories_by_user_seacret_id
  );

  sub create_result($self, $contents) {
    HirakataPapark::Model::Result->new(contents => $contents);
  }

}

1;
