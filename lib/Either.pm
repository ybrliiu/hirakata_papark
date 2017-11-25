package Either {

  use v5.14;
  use warnings;

  our $VERSION = '0.01';

  use Carp;
  use Either::Right;
  use Either::Left;

  use Exporter qw( import );
  our @EXPORT = qw( right left );

  sub right($) { Either::Right->new($_[0]) }

  sub left($) { Either::Left->new($_[0]) }

}

1;

__END__

-Either::Projection
|-Either::RightProjection
|-Either::LeftProjection
|-Either::Either
 |-Either::Right
 |-Either::Left
