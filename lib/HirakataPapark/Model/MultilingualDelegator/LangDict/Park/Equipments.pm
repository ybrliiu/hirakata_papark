package HirakataPapark::Model::MultilingualDelegator::LangDict::Park::Equipments {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Model::LangDict::Park::Equipments::Ja;
  use HirakataPapark::Model::LangDict::Park::Equipments::En;

  with 'HirakataPapark::Model::MultilingualDelegator::LangDict::LangDict';

  sub _build_lang_dict_class_names_table($self) {
    {
      ja => 'HirakataPapark::Model::LangDict::Park::Equipments::Ja',
      en => 'HirakataPapark::Model::LangDict::Park::Equipments::En',
    };
  }

  __PACKAGE__->meta->make_immutable;

}

1;
