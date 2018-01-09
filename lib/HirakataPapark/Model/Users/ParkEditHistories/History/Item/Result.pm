package HirakataPapark::Model::Users::ParkEditHistories::History::Item::Result {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;

  has 'lang' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Types::Lang',
    required => 1,
  );

  with 'HirakataPapark::Model::Users::ParkEditHistories::History::Item::Item';

  __PACKAGE__->meta->make_immutable;

}

1;
