package HirakataPapark::Model::Users::ParkEditHistories::SurroundingFacility::LangRecord {
  
  use Mouse;
  use HirakataPapark;

  use constant COLUMN_NAMES => [qw( name comment )];

  with 'HirakataPapark::Model::Users::ParkEditHistories::History::LangRecord';

  __PACKAGE__->add_attributes;

  __PACKAGE__->meta->make_immutable;

}

1;
