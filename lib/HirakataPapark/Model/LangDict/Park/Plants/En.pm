package HirakataPapark::Model::LangDict::Park::Plants::En {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Model::LangDict::LangDict';

  sub _build_words_dict($self) {
    my $data = {
      yoshino_cherry  => 'Yoshino cherry',
      oshima_cherry   => 'Oshima cherry',
      kanhi_zakura    => 'Kanhizakura',
      shidare_zakura  => 'Shidarezakura',
      kawadu_zakura   => 'Kawaduzakura',
      yama_zakura     => 'Yamazakura',
      sato_zakura     => 'Satozakura',
      yae_zakura      => 'Yaezakura',
      amanogawa       => 'Amanogawa',
      yaeakebono      => 'Yaeakebono',
      hakusamoodemari => 'Hakusamoodemari',
      kouyou_zakura   => 'Kouyouzakura',
      ooyama_zakura   => 'Ooyamazakura',
      yaebenishidare  => 'Yaebenishidare', 
    };
  }

  sub _build_functions_dict($self) {
    +{};
  }

  __PACKAGE__->meta->make_immutable;

}

1;
