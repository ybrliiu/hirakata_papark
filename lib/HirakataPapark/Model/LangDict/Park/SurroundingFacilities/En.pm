package HirakataPapark::Model::LangDict::Park::SurroundingFacilities::En {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Model::LangDict::LangDict';

  sub _build_words_dict($self) {
    my $data = {
      toll_parking => 'Toll parking',
      free_parking => 'Free parking',
    };
  }

  sub _build_functions_dict($self) {
    +{};
  }

  __PACKAGE__->meta->make_immutable;

}

1;
