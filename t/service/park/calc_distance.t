use Test::HirakataPapark;
use HirakataPapark::Class::Coord;

use_ok 'HirakataPapark::Service::Park::CalcDistance';

my $coord1 = HirakataPapark::Class::Coord->new(
  x => 135.5253887,
  y => 34.8340993,
);
my $coord2 = HirakataPapark::Class::Coord->new(
  x => 139.7215902,
  y => 35.625157,
);

my $calculator = HirakataPapark::Service::Park::CalcDistance->new(
  coord1 => $coord1,
  coord2 => $coord2,
);

my $result;
lives_ok { $result = $calculator->calc() };
is $result, 391942.709293182;

done_testing;

