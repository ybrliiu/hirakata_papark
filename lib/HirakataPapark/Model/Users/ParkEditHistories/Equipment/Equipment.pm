package HirakataPapark::Model::Users::ParkEditHistories::Equipment::Equipment {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Model::Users::ParkEditHistories::Equipment::LangRecord;

  use constant COLUMN_NAMES => [
    qw( num recommended_age ),
    HirakataPapark::Model::Users::ParkEditHistories::Equipment::LangRecord->COLUMN_NAMES->@*,
  ];

  has 'num' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
  );

  has 'recommended_age' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
  );

  with 'HirakataPapark::Model::Users::ParkEditHistories::OneToMany::Item::ItemImpl';

  __PACKAGE__->meta->make_immutable;

}

1;
