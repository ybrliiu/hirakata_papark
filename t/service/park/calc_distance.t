use HirakataPapark 'test';
use HirakataPapark::DB::Row::Park;

use_ok 'HirakataPapark::Service::Park::CalcDistance';

package Point {
  use Mouse;
  has [qw/ x y /] => ( is => 'ro', isa => 'Num', required => 1 );
  __PACKAGE__->meta->make_immutable;
}

my $park1 = Point->new(
  x => 135.5253887,
  y => 34.8340993,
);
my $park2 = Point->new(
  x => 139.7215902,
  y => 35.625157,
);

my $calculator = HirakataPapark::Service::Park::CalcDistance->new(
  park1 => $park1,
  park2 => $park2,
);

my $result;
lives_ok { $result = $calculator->calc() };
is $result, 391942.709293182;

done_testing;

