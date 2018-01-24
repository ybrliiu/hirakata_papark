package HirakataPapark::Model::Users::ParkEditHistories::ParkEditHistories {

  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Model::Result;

  with 'HirakataPapark::Model::Role::DB';

  # attributes
  requires qw( tables_meta );

  # methods
  requires qw(
    add_history
    get_histories_by_park_id
    get_histories_by_user_seacret_id
  );

}

1;
