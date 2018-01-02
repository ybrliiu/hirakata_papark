package HirakataPapark::Class::LangDict::Ja {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Validator::DefaultMessageData;

  with 'HirakataPapark::Class::LangDict::LangDict';

  my $site_config = HirakataPapark::Model::Config->instance->get_config('site');
  my $param = HirakataPapark::Validator::DefaultMessageData
    ->instance->message_data('ja')->param;

  sub _build_lang_dict($self) {
    my $data = {
      %$param,
      site_name            => $site_config->{name},
      park_map             => '公園マップ',
      nearby_parks         => '現在地周辺の公園',
      mypage               => 'マイページ',
      login                => 'ログイン',
      logout               => 'ログアウト',
      user_registration    => 'ユーザー登録',
      address              => '住所',
      latitude             => '緯度',
      longitude            => '経度',
      area                 => '面積',
      extent               => '広さ',
      scenery              => '景観',
      nice                 => '良い',
      temp_evacuation_area => '一時避難場所',
      name                 => '名前',
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
      profile              => 'プロフィール',
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
      length_func          => sub ($min, $max) {
        "${min}文字以上${max}文字以下で入力してください。";
      },
      distance_func        => sub ($distance) {
        "周辺 ${distance}m 以内にある公園を検索";
      },
    };
    $data->{search_by_func} = sub ($key) {
      "$data->{$key}から$data->{search}";
    };
    $data->{please_input_func} = sub ($key) {
      "$data->{$key}を入力してください";
    };
    $data->{plants_in_func} = sub ($park_name) {
      "${park_name}の$data->{plants}";
    };
    $data;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

