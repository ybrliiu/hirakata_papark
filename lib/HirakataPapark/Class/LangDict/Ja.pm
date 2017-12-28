package HirakataPapark::Class::LangDict::Ja {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Validator::DefaultMessageData;

  with 'HirakataPapark::Class::LangDict::LangDict';

  my $param = HirakataPapark::Validator::DefaultMessageData
    ->instance->message_data('ja')->param;

  sub _build_lang_dict($self) {
    +{
      %$param,
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
      variety              => '品種名',
      back                 => '戻る',
      search               => '検索',
      search_result        => '検索結果',
      registration         => '登録',
      profile              => 'プロフィール',
      login                => 'ログイン',
      regist_from_twitter  => 'Twitterから登録',
      post_park_image      => '公園の画像を投稿',
      select_image         => '画像を選択',
      length_func          => sub ($min, $max) {
        "${min}文字以上${max}文字以下で入力してください。";
      },
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

