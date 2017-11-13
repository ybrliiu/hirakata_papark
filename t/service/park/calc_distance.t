use HirakataPapark 'test';
use HirakataPapark::Class::Point;

use_ok 'HirakataPapark::Service::Park::CalcDistance';

package Point {
  use Mouse;
  has [qw/ x y /] => ( is => 'ro', isa => 'Num', required => 1 );
  __PACKAGE__->meta->make_immutable;
}

my $point1 = HirakataPapark::Class::Point->new(
  x => 135.5253887,
  y => 34.8340993,
);
my $point2 = HirakataPapark::Class::Point->new(
  x => 139.7215902,
  y => 35.625157,
);

my $calculator = HirakataPapark::Service::Park::CalcDistance->new(
  point1 => $point1,
  point2 => $point2,
);

my $result;
lives_ok { $result = $calculator->calc() };
is $result, 391942.709293182;

done_testing;

