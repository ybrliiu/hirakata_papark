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
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

