package HirakataPapark::Model::MultilingualDelegator::Parks::Plants {

  use Mouse;
  use HirakataPapark;

  use HirakataPapark::Model::Parks::Plants;
  use HirakataPapark::Model::Parks::EnglishPlants;

  has 'model_instances' => (
    is      => 'ro',
    isa     => 'HashRef[HirakataPapark::Model::Role::DB::Parks::Plants]',
    default => sub ($self) { +{} },
  );

  with 'HirakataPapark::Model::Role::MultilingualDelegator';

  sub _build_lang_to_model_table($self) {
    {
      ja => 'HirakataPapark::Model::Parks::Plants',
      en => 'HirakataPapark::Model::Parks::EnglishPlants',
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

