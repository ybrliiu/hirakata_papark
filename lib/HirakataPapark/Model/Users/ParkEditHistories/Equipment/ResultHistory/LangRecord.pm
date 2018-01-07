package HirakataPapark::Model::Users::ParkEditHistories::Equipment::ResultHistory::LangRecord {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Model::Users::ParkEditHistories::Equipment::History::LangRecord;
  
  my $columns
    = HirakataPapark::Model::Users::ParkEditHistories::Equipment::History::LangRecord::COLUMNS;
  for my $attr_name (@$columns) {
    has $attr_name => (
      is       => 'ro',
      isa      => 'Str',
      required => 1,
    );
  }

  with 'HirakataPapark::Model::Users::ParkEditHistories::Equipment::History::LangRecord';

  __PACKAGE__->meta->make_immutable;

}

1;
