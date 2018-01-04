package HirakataPapark::Model::LangDict::Park::SurroundingFacilities::Ja {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Model::LangDict::LangDict';

  sub _build_words_dict($self) {
    my $data = {
      toll_parking => '有料駐車場',
      free_parking => '無料駐車場',
    };
  }

  sub _build_functions_dict($self) {
    +{};
  }

  __PACKAGE__->meta->make_immutable;

}

1;
