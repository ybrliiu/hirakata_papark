package HirakataPapark::Model::Users::ParkEditHistories::Equipment::ResultHistory::LangRecords {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;

  my $LangRecord =
    'HirakataPapark::Model::Users::ParkEditHistories::Equipment::ResultHistory::LangRecord';

  for my $lang (HirakataPapark::Types->LANGS->@*) {
    has $lang => (
      is       => 'ro',
      isa      => $LangRecord,
      required => 1,
    );
  }

  with 'HirakataPapark::Model::Users::ParkEditHistories::Equipment::History::LangRecords';

  __PACKAGE__->meta->make_immutable;

}

1;
