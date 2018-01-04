package HirakataPapark::Model::LangDict::Park::Equipments::En {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Model::LangDict::LangDict';

  sub _build_words_dict($self) {
    my $data = {
      swing                   => 'Swing',
      slide                   => 'Slide',
      horizontal_bar          => 'Horizontal bar',
      seesaw                  => 'Seesaw',
      jungle_gym              => 'Jungle gym',
      combined_play_equipment => 'Combined play equipment',
      sandbox                 => 'Sandbox',
      ladder                  => 'Ladder',
      healthy_play_equipment  => 'Healthy play equipment',
      play_sculpture          => 'Play sculpture',
      toilet                  => 'Toilet',
      drinking_fountains      => 'Drinking fountains',
      bench                   => 'Bench',
      chickee                 => 'Chickee',
    };
  }

  sub _build_functions_dict($self) {
    +{};
  }

  __PACKAGE__->meta->make_immutable;

}

1;
