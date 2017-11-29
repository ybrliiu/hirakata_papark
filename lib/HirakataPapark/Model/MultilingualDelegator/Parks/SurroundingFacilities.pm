package HirakataPapark::Model::MultilingualDelegator::Parks::SurroundingFacilities {

  use Mouse;
  use HirakataPapark;

  use HirakataPapark::Model::Parks::SurroundingFacilities;
  use HirakataPapark::Model::Parks::EnglishSurroundingFacilities;

  has 'model_instances' => (
    is      => 'ro',
    isa     => 'HashRef[HirakataPapark::Model::Role::DB::Parks::SurroundingFacilities]',
    default => sub ($self) { +{} },
  );

  with 'HirakataPapark::Model::Role::MultilingualDelegator';

  sub _build_lang_to_model_table($self) {
    {
      ja => 'HirakataPapark::Model::Parks::SurroundingFacilities',
      en => 'HirakataPapark::Model::Parks::EnglishSurroundingFacilities',
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

