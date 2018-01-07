package HirakataPapark::Model::Users::ParkEditHistories::Equipment::History::LangRecord {
  
  use Mouse::Role;
  use HirakataPapark;

  sub COLUMNS { [qw( name comment )] }

  # attributes
  requires @{ COLUMNS() };

}

1;
