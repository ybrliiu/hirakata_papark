package HirakataPapark::Model::Users::ParkEditHistories::History::History::HasMany::Result {

  use Mouse;
  use HirakataPapark;

  has 'id' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
  );

  with 'HirakataPapark::Model::Users::ParkEditHistories::History::History::HasMany::History';

  __PACKAGE__->meta->make_immutable;

}

1;
