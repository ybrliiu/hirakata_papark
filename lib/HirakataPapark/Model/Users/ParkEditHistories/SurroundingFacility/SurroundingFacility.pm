package HirakataPapark::Model::Users::ParkEditHistories::SurroundingFacility::SurroundingFacility {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Model::Users::ParkEditHistories::SurroundingFacility::LangRecord;

  use constant COLUMN_NAMES => 
    HirakataPapark::Model::Users::ParkEditHistories::SurroundingFacility::LangRecord->COLUMN_NAMES;

  with 'HirakataPapark::Model::Users::ParkEditHistories::History::Item::ItemImpl';

  __PACKAGE__->meta->make_immutable;

}

1;
