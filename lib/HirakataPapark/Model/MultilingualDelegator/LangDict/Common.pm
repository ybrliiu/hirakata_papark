package HirakataPapark::Model::MultilingualDelegator::LangDict::Common {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Model::LangDict::Common::Ja;
  use HirakataPapark::Model::LangDict::Common::En;

  with 'HirakataPapark::Model::MultilingualDelegator::LangDict::LangDict';

  sub _build_lang_dict_class_names_table($self) {
    {
      ja => 'HirakataPapark::Model::LangDict::Common::Ja',
      en => 'HirakataPapark::Model::LangDict::Common::En',
    };
  }

  __PACKAGE__->meta->make_immutable;

}

1;
