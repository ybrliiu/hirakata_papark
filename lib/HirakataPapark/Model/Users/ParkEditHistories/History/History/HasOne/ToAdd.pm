package HirakataPapark::Model::Users::ParkEditHistories::History::History::HasOne::ToAdd {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::Model::Users::ParkEditHistories::History::Item::ToAdd';
  with 'HirakataPapark::Model::Users::ParkEditHistories::History::History::History';

  __PACKAGE__->meta->make_immutable;

}

1;
