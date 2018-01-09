package HirakataPapark::Model::Users::ParkEditHistories::History::History::HasOne::Result {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::Model::Users::ParkEditHistories::History::Item::Result';
  with 'HirakataPapark::Model::Users::ParkEditHistories::History::History::History';

  __PACKAGE__->meta->make_immutable;

}

1;
