package HirakataPapark::Model::LangDict::Park::PlantsCategories::En {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Model::LangDict::LangDict';

  sub _build_words_dict($self) {
    my $data = {
      cherry_blossoms => 'Cherry Blossoms',
    };
  }

  sub _build_functions_dict($self) {
    +{};
  }

  __PACKAGE__->meta->make_immutable;

}

1;
