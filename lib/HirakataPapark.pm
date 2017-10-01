package HirakataPapark 0.01 {

  use strict;
  use warnings;
  use utf8;
  use feature qw( :5.24 signatures );
  no warnings 'experimental::signatures';

  use Data::Dumper;
  use Module::Load 'autoload_remote';

  # Data::Dumper utf8対応
  {
    no warnings 'redefine';
    *Data::Dumper::qquote = sub { shift };
  }
  $Data::Dumper::Useperl = 1;

  sub import {
    my ($class, $option) = @_;
    $option //= '';

    if ($option eq 'test') {
      unshift @INC, './t/lib'; # テストの時パス追加
      my $pkg = caller;
      my @load = qw( Test::More Test::Exception Test::Name::FromLine );
      autoload_remote($pkg, $_) for @load;
    }

    $class->import_pragma;
  }
  
  sub import_pragma {
    my ($class) = @_;
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
