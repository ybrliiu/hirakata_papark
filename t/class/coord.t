use Test::HirakataPapark;

use_ok 'HirakataPapark::Class::Coord';

my $point;
lives_ok {
  $point = HirakataPapark::Class::Coord->new(
    x => 135.5253887,
    y => 34.8340993,
  );
};

done_testing;

