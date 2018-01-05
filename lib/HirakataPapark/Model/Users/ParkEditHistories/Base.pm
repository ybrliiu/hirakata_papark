package HirakataPapark::Model::Users::ParkEditHistories::Base {

  use Mouse::Role;
  use HirakataPapark;

  # constants
  requires qw( TABLE_NAME );

  has 'db' => (
    is       => 'ro',
    isa      => 'HirakataPapark::DB',
    required => 1,
  );

}

1;
