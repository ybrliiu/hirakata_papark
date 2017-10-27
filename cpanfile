requires 'perl', '5.024001';
requires 'Mouse';
requires 'Smart::Args';
requires 'Mojolicious';
requires 'Aniki';
requires 'Anego', '== 0.01_02';
requires 'Config::PL';
requires 'HTML::Escape';
requires 'Mojolicious::Plugin::AssetPack';
requires 'Mojolicious::Plugin::ProxyPassReverse::SubDir';

on 'test' => sub {
  requires 'Path::Tiny';
};

on 'develop' => sub {
  requires 'Path::Tiny';
  requires 'Lingua::JA::Romanize::Japanese';
  requires 'Unicode::Japanese';
};
