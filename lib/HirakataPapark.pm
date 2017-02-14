package HirakataPapark 0.01 {

  use strict;
  use warnings;
  use utf8;
  use feature qw( :5.24 );

  sub import {
    my ($class, $option) = @_;
    $class->import_pragma;
  }
  
  sub import_pragma {
    my ($class) = @_;
    $_->import for qw( strict warnings utf8 );
    feature->import(':5.24');
  }
  
}

1;

=encoding utf8

=head1 NAME
  ひらかたぱぱーく

=cut
