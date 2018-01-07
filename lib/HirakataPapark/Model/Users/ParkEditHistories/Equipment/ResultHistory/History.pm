package HirakataPapark::Model::Users::ParkEditHistories::Equipment::ResultHistory::History {

  use Mouse;
  use HirakataPapark;
  with 'HirakataPapark::Model::Users::ParkEditHistories::Equipment::History::History';

  has 'id' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
  );

  __PACKAGE__->meta->make_immutable;

}

1;
