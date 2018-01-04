package HirakataPapark::Model::MultilingualDelegator::LangDict::Park::Plants {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Model::LangDict::Park::Plants::Ja;
  use HirakataPapark::Model::LangDict::Park::Plants::En;

  with 'HirakataPapark::Model::MultilingualDelegator::LangDict::LangDict';

  sub _build_lang_dict_class_names_table($self) {
    {
      ja => 'HirakataPapark::Model::LangDict::Park::Plants::Ja',
      en => 'HirakataPapark::Model::LangDict::Park::Plants::En',
    };
  }

  __PACKAGE__->meta->make_immutable;

}

1;
