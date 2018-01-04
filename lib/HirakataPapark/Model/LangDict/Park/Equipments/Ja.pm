package HirakataPapark::Model::LangDict::Park::Equipments::Ja {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Model::LangDict::LangDict';

  sub _build_words_dict($self) {
    my $data = {
      swing                   => 'ブランコ',
      slide                   => 'すべり台',
      horizontal_bar          => '鉄棒',
      seesaw                  => 'シーソー',
      jungle_gym              => 'ジャングルジム',
      combined_play_equipment => '鋼製複合遊具',
      sandbox                 => '砂場',
      ladder                  => 'ラダー',
      healthy_play_equipment  => '健康遊具',
      play_sculpture          => 'プレイスカルプチャー(遊戯彫刻)',
      toilet                  => 'トイレ',
      drinking_fountains      => '水飲場',
      bench                   => 'ベンチ',
      chickee                 => '四阿・シェルター',
    };
  }

  sub _build_functions_dict($self) {
    +{};
  }

  __PACKAGE__->meta->make_immutable;

}

1;
