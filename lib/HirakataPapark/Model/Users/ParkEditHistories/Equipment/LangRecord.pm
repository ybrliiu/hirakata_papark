package HirakataPapark::Model::Users::ParkEditHistories::Equipment::LangRecord {
  
  use Mouse;
  use HirakataPapark;

  use constant COLUMN_NAMES => [qw( name comment )];

  with 'HirakataPapark::Model::Users::ParkEditHistories::OneToMany::LangRecord';

  __PACKAGE__->add_attributes;

  __PACKAGE__->meta->make_immutable;

}

1;
