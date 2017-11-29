requires 'perl', '5.024001';
requires 'Mouse';
requires 'Smart::Args';
requires 'Try::Tiny';
requires 'Exception::Tiny';
requires 'Aniki';
requires 'Anego', '== 0.01_02';
requires 'Config::PL';
requires 'Mojolicious';
requires 'HTML::Escape';
requires 'FormValidator::Lite';
requires 'Mojolicious::Plugin::AssetPack';
requires 'Mojolicious::Plugin::ProxyPassReverse::SubDir';

on 'test' => sub {
  requires 'Path::Tiny';
  requires 'Bread::Board';
};

on 'develop' => sub {
  requires 'Path::Tiny';
  requires 'Text::CSV_XS';
  requires 'Lingua::JA::Romanize::Japanese';
  requires 'Unicode::Japanese';
};

