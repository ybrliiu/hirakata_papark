package HirakataPapark 0.01 {

  use strict;
  use warnings;
  use utf8;
  use feature qw( :5.24 signatures );

  # 言語の略名は ISO 639-1 を利用
  # see also https://ja.wikipedia.org/wiki/ISO_639-1%E3%82%B3%E3%83%BC%E3%83%89%E4%B8%80%E8%A6%A7
  use constant DEFAULT_LANG  => 'ja';
  use constant FOREIGN_LANGS => [qw( en )];
  use constant LANG          => [ DEFAULT_LANG, FOREIGN_LANGS->@* ];
  use constant LANG_TABLE    => { map { $_ => 1 } LANG->@* };

  use Data::Dumper;
  use Module::Load 'autoload_remote';
  use Mouse::Util::TypeConstraints qw( enum );
  no warnings 'experimental::signatures';

  # 独自型定義
  enum 'HirakataPapark::lang' => LANG;

  # Data::Dumper utf8対応
  {
    no warnings 'redefine';
    *Data::Dumper::qquote = sub { shift };
  }
  $Data::Dumper::Useperl = 1;

  sub import($class, $option = '') {

    my $pkg = caller;

    if ($option eq 'test') {
      unshift @INC, './t/lib'; # テストの時パス追加
      my @load = qw(
        Test::More
        Test::Exception
        Test2::Plugin::UTF8
      );
      autoload_remote($pkg, $_) for @load;
      autoload_remote($pkg, 'Test2::Plugin::Name::FromLine', is_guess_test_line => 1);
    }

    $class->import_pragma;
  }
  
  sub import_pragma($class) {
    $_->import for qw( strict warnings utf8 );
    feature->import(qw/ :5.24 signatures /);
    warnings->unimport('experimental::signatures');
  }
  
}

1;

=encoding utf8

=head1 NAME
  ひらかたぱぱーく

=cut
