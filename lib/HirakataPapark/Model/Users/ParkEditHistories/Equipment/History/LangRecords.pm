package HirakataPapark::Model::Users::ParkEditHistories::Equipment::History::LangRecords {
  
  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Types;

  # attributes
  requires @{ HirakataPapark::Types->LANGS };

}

1;
