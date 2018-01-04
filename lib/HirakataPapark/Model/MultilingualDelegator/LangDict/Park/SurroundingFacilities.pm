package HirakataPapark::Model::MultilingualDelegator::LangDict::Park::SurroundingFacilities {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Model::LangDict::Park::SurroundingFacilities::Ja;
  use HirakataPapark::Model::LangDict::Park::SurroundingFacilities::En;

  with 'HirakataPapark::Model::MultilingualDelegator::LangDict::LangDict';

  sub _build_lang_dict_class_names_table($self) {
    {
      ja => 'HirakataPapark::Model::LangDict::Park::SurroundingFacilities::Ja',
      en => 'HirakataPapark::Model::LangDict::Park::SurroundingFacilities::En',
    };
  }

  __PACKAGE__->meta->make_immutable;

}

1;
