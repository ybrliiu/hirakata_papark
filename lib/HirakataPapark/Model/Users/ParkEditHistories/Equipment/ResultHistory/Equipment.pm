package HirakataPapark::Model::Users::ParkEditHistories::Equipment::ResultHistory::Equipment {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;

  has 'lang' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Types::Lang',
    required => 1,
  );

  with 'HirakataPapark::Model::Users::ParkEditHistories::Equipment::History::Equipment';

  __PACKAGE__->meta->make_immutable;

}

1;
