package HirakataPapark::Model::Users::ParkEditHistories::Plants::ResultHistoryBuilder {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Model::Users::ParkEditHistories::Plants::Plants;
  use HirakataPapark::Model::Users::ParkEditHistories::Plants::LangRecord;

  with 'HirakataPapark::Model::Users::ParkEditHistories::ResultHistoryBuilder::HasMany';

  my $Plants   = 'HirakataPapark::Model::Users::ParkEditHistories::Plants::Plants';
  my $LangRecord  = 'HirakataPapark::Model::Users::ParkEditHistories::Plants::LangRecord';

  sub _build_prefix_length($self) {
    length $Plants->build_prefix;
  }

  sub _create_item_impl($self, $args) {
    $Plants->new($args);
  }

  sub _create_lang_record($self, $args) {
    $LangRecord->new($args);
  }
  
  __PACKAGE__->meta->make_immutable;

}

1;
