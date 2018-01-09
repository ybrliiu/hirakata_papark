package HirakataPapark::Model::Users::ParkEditHistories::SurroundingFacility::ResultHistoryBuilder {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Model::Users::ParkEditHistories::SurroundingFacility::SurroundingFacility;
  use HirakataPapark::Model::Users::ParkEditHistories::SurroundingFacility::LangRecord;

  with 'HirakataPapark::Model::Users::ParkEditHistories::ResultHistoryBuilder::HasMany';

  my $SurroundingFacility =
    'HirakataPapark::Model::Users::ParkEditHistories::SurroundingFacility::SurroundingFacility';
  my $LangRecord =
    'HirakataPapark::Model::Users::ParkEditHistories::SurroundingFacility::LangRecord';

  sub _build_prefix_length($self) {
    length $SurroundingFacility->build_prefix;
  }

  sub _create_item_impl($self, $args) {
    $SurroundingFacility->new($args);
  }

  sub _create_lang_record($self, $args) {
    $LangRecord->new($args);
  }
  
  __PACKAGE__->meta->make_immutable;

}

1;
