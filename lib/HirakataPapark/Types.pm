package HirakataPapark::Types {

  use Mouse::Util::TypeConstraints qw( enum );
  use HirakataPapark;

  # 言語の略名は ISO 639-1 を利用
  # see also https://ja.wikipedia.org/wiki/ISO_639-1%E3%82%B3%E3%83%BC%E3%83%89%E4%B8%80%E8%A6%A7
  use constant DEFAULT_LANG  => 'ja';
  use constant FOREIGN_LANGS => [qw( en )];
  use constant LANGS         => [ DEFAULT_LANG, FOREIGN_LANGS->@* ];
  use constant LANGS_TABLE   => { map { $_ => 1 } LANGS->@* };

  sub other_langs($class, $lang) {
    [ grep { $lang ne $_ } LANGS->@* ];
  }

  enum 'HirakataPapark::Types::Lang' => LANGS;

}

1;
