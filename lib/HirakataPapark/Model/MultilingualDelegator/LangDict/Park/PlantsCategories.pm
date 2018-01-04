package HirakataPapark::Model::MultilingualDelegator::LangDict::Park::PlantsCategories {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Model::LangDict::Park::PlantsCategories::Ja;
  use HirakataPapark::Model::LangDict::Park::PlantsCategories::En;

  with 'HirakataPapark::Model::MultilingualDelegator::LangDict::LangDict';

  sub _build_lang_dict_class_names_table($self) {
    {
      ja => 'HirakataPapark::Model::LangDict::Park::PlantsCategories::Ja',
      en => 'HirakataPapark::Model::LangDict::Park::PlantsCategories::En',
    };
  }

  __PACKAGE__->meta->make_immutable;

}

1;
