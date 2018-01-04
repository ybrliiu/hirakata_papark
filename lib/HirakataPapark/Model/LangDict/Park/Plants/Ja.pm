package HirakataPapark::Model::LangDict::Park::Plants::Ja {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Model::LangDict::LangDict';

  sub _build_words_dict($self) {
    my $data = {
      yoshino_cherry  => 'ソメイヨシノ',
      oshima_cherry   => 'オオシマザクラ',
      kanhi_zakura    => 'カンヒザクラ',
      shidare_zakura  => 'シダレザクラ',
      kawadu_zakura   => 'カワヅザクラ',
      yama_zakura     => 'ヤマザクラ',
      sato_zakura     => 'サトザクラ',
      yae_zakura      => 'ヤエザクラ',
      amanogawa       => 'アマノガワ',
      yaeakebono      => 'ヤエアケボノ',
      hakusamoodemari => 'ハクサンオオデマリ',
      kouyou_zakura   => 'コウヨウザクラ',
      ooyama_zakura   => 'オオヤマザクラ',
      yaebenishidare  => 'ヤエベニシダレ',
    };
  }

  sub _build_functions_dict($self) {
    +{};
  }

  __PACKAGE__->meta->make_immutable;

}

1;
