package HirakataPapark 0.01 {

  use strict;
  use warnings;
  use utf8;
  use feature qw( :5.24 signatures );
  no warnings 'experimental::signatures';

  # Data::Dumper utf8対応
  use Data::Dumper;
  {
    no warnings 'redefine';
    *Data::Dumper::qquote = sub { shift };
  }
  $Data::Dumper::Useperl = 1;

  sub import($class) {
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
