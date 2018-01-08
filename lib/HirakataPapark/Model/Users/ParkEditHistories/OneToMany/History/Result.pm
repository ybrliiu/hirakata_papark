package HirakataPapark::Model::Users::ParkEditHistories::OneToMany::History::Result {

  use Mouse;
  use HirakataPapark;

  has 'id' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
  );

  with 'HirakataPapark::Model::Users::ParkEditHistories::OneToMany::History::History';

  __PACKAGE__->meta->make_immutable;

}

1;
