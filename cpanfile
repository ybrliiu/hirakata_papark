requires 'perl', '5.024001';
requires 'Mouse';
requires 'Smart::Args';
requires 'PadWalker';
requires 'Try::Tiny';
requires 'Exception::Tiny';
requires 'Aniki';
requires 'DBI';
requires 'DBD::Pg';
requires 'Anego', '== 0.02';
requires 'Daiku';
requires 'Config::PL';
requires 'Set::Object';
requires 'Mojolicious';
requires 'HTML::Escape';
requires 'FormValidator::Lite';
requires 'Mojolicious::Plugin::AssetPack';
requires 'CSS::Sass';
requires 'Mojolicious::Plugin::PlackMiddleware';
requires 'Mojolicious::Plugin::ProxyPassReverse::SubDir';
requires 'Plack';
requires 'Plack::Middleware::Session';

on 'test' => sub {
  requires 'Path::Tiny';
  requires 'Bread::Board';
  requires 'Test::More';
  requires 'Test::Exception';
  requires 'Test2::Plugin::UTF8';
  requires 'Test2::Plugin::SourceDiag';
};

on 'develop' => sub {
  requires 'Path::Tiny';
  requires 'Text::CSV_XS';
  # requires 'Lingua::JA::Romanize::Japanese';
  requires 'Unicode::Japanese';
};

