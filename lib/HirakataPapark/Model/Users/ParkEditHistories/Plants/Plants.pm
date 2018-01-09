package HirakataPapark::Model::Users::ParkEditHistories::Plants::Plants {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Model::Users::ParkEditHistories::Plants::LangRecord;

  use constant COLUMN_NAMES => [
    qw( num ),
    HirakataPapark::Model::Users::ParkEditHistories::Plants::LangRecord->COLUMN_NAMES->@*,
  ];

  has 'num' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
  );

  with 'HirakataPapark::Model::Users::ParkEditHistories::History::Item::ItemImpl';

  __PACKAGE__->meta->make_immutable;

}

1;
