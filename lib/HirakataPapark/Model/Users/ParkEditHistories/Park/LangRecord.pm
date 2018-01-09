package HirakataPapark::Model::Users::ParkEditHistories::Park::LangRecord {
  
  use Mouse;
  use HirakataPapark;

  use constant COLUMN_NAMES => [qw( name address explain )];

  with 'HirakataPapark::Model::Users::ParkEditHistories::History::LangRecord';

  __PACKAGE__->add_attributes;

  __PACKAGE__->meta->make_immutable;

}

1;
