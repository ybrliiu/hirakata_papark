package HirakataPapark::Model::MultilingualDelegator::Parks::Equipments {

  use Mouse;
  use HirakataPapark;

  use HirakataPapark::Model::Parks::Equipments;
  use HirakataPapark::Model::Parks::EnglishEquipments;

  has 'model_instances' => (
    is      => 'ro',
    isa     => 'HashRef[HirakataPapark::Model::Role::DB::Parks::Equipments]',
    default => sub ($self) { +{} },
  );

  with 'HirakataPapark::Model::Role::MultilingualDelegator';

  sub _build_lang_to_model_table($self) {
    {
      ja => 'HirakataPapark::Model::Parks::Equipments',
      en => 'HirakataPapark::Model::Parks::EnglishEquipments',
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

