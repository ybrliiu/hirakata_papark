package HirakataPapark 0.01 {

  use strict;
  use warnings;
  use utf8;
  use feature qw( :5.24 signatures );
  no warnings 'experimental::signatures';

  use constant LANG => [qw/ ja en /];

  use Data::Dumper;
  use Module::Load 'autoload_remote';
  use Mouse::Util::TypeConstraints qw( enum );

  # Data::Dumper utf8対応
  {
    no warnings 'redefine';
    *Data::Dumper::qquote = sub { shift };
  }
  $Data::Dumper::Useperl = 1;

  sub import {
    my ($class, $option) = @_;
    $option //= '';

    my $pkg = caller;

    if ($option eq 'test') {
      unshift @INC, './t/lib'; # テストの時パス追加
      my @load = qw(
        Test::More
        Test::Exception
        Test2::Plugin::UTF8
        Test2::Plugin::SourceDiag
      );
      autoload_remote($pkg, $_) for @load;
      autoload_remote($pkg, 'Test2::Plugin::Name::FromLine', is_guess_test_line => 1);
    }

    $class->import_pragma;
  }
  
  sub import_pragma {
    my ($class) = @_;
    $_->import for qw( strict warnings utf8 );
    feature->import(qw/ :5.24 signatures /);
    warnings->unimport('experimental::signatures');
  }

  # 独自型定義
  enum 'HirakataPapark::lang' => LANG;
  
}

1;

=encoding utf8

=head1 NAME
  ひらかたぱぱーく

=cut
