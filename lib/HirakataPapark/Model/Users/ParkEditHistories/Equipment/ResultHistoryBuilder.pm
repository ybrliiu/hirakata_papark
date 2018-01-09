package HirakataPapark::Model::Users::ParkEditHistories::Equipment::ResultHistoryBuilder {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Model::Users::ParkEditHistories::Equipment::Equipment;
  use HirakataPapark::Model::Users::ParkEditHistories::Equipment::LangRecord;

  with 'HirakataPapark::Model::Users::ParkEditHistories::ResultHistoryBuilder::HasMany';

  my $Equipment   = 'HirakataPapark::Model::Users::ParkEditHistories::Equipment::Equipment';
  my $LangRecord  = 'HirakataPapark::Model::Users::ParkEditHistories::Equipment::LangRecord';

  sub _build_prefix_length($self) {
    length $Equipment->build_prefix;
  }

  sub _create_item_impl($self, $args) {
    $Equipment->new($args);
  }

  sub _create_lang_record($self, $args) {
    $LangRecord->new($args);
  }
  
  __PACKAGE__->meta->make_immutable;

}

1;
