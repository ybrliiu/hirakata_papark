package HirakataPapark::Model::LangDict::Common::Ja {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Model::LangDict::LangDict';

  sub _build_words_dict($self) {
    my $data = {
      name                 => '名前',
      id                   => 'ID',
      password             => 'パスワード',
      address              => '住所',
      zipcode              => '郵便番号',
      profile              => 'プロフィール',
      twitter_id           => 'Twitter ID',
      facebook_id          => 'Facebook ID',
      park_id              => '公園ID',
      tag_name             => 'タグ名',
      image_file           => '画像ファイル',
      site_name            => 'ひらかたパパーク',
      park_map             => '公園マップ',
      nearby_parks         => '現在地周辺の公園',
      mypage               => 'マイページ',
      login                => 'ログイン',
      logout               => 'ログアウト',
      user_registration    => 'ユーザー登録',
      latitude             => '緯度',
      longitude            => '経度',
      area                 => '面積',
      extent               => '広さ',
      scenery              => '景観',
      nice                 => '良い',
      temp_evacuation_area => '一時避難場所',
      text_body            => '本文',
      num                  => '個数',
      remarks              => '備考',
      details              => '詳細',
      post                 => '投稿',
      category             => 'カテゴリ',
      plants               => '植物',
      variety              => '品種名',
      back                 => '戻る',
      search               => '検索',
      search_result        => '検索結果',
      registration         => '登録',
      login                => 'ログイン',
      regist_from_twitter  => 'Twitterから登録',
      map                  => '地図',
      images               => '画像',
      post_park_image      => '公園の画像を投稿',
      select_image         => '画像を選択',
      overview             => '概要',
      comments             => 'コメント',
      park_name            => '公園の名前',
      tag                  => 'タグ',
      equipment            => '遊具・施設',
      surrounding_facility => '周辺施設',
      search_park          => '公園を検索',
      add_tag              => 'タグをつける',
      tag_list             => 'タグ一覧',
    };
  }

  sub _build_functions_dict($self) {
    my $words = $self->words_dict;
    +{
      length => sub ($min, $max) {
        "${min}文字以上${max}文字以下で入力してください。";
      },
      distance => sub ($distance) {
        "周辺 ${distance}m 以内にある公園を検索";
      },
      search_by => sub ($key) {
        "$words->{$key}から$words->{search}";
      },
      please_input => sub ($key) {
        "$words->{$key}を入力してください";
      },
      plants_in => sub ($park_name) {
        "${park_name}の$words->{plants}";
      },
    };
  }

  __PACKAGE__->meta->make_immutable;

}

1;
