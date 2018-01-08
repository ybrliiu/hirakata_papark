package HirakataPapark::Model::Users::ParkEditHistories::OneToMany::Item::Result {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;

  has 'lang' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Types::Lang',
    required => 1,
  );

  with 'HirakataPapark::Model::Users::ParkEditHistories::OneToMany::Item::Item';

  __PACKAGE__->meta->make_immutable;

}

1;
