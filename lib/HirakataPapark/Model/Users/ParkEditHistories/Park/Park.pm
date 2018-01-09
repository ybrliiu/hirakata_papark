package HirakataPapark::Model::Users::ParkEditHistories::Park::Park {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Model::Users::ParkEditHistories::Park::LangRecord;

  use constant COLUMN_NAMES => [
    qw( zipcode x y area is_evacuation_area ),
    HirakataPapark::Model::Users::ParkEditHistories::Park::LangRecord->COLUMN_NAMES->@*,
  ];

  has 'zipcode' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  for my $name (qw/ x y area /) {
    has $name => (
      is       => 'ro',
      isa      => 'Num',
      required => 1,
    );
  }

  has 'is_evacuation_area' => (
    is       => 'ro',
    isa      => 'Bool',
    required => 1,
  );

  with 'HirakataPapark::Model::Users::ParkEditHistories::History::Item::ItemImpl';

  __PACKAGE__->meta->make_immutable;

}

1;
