use HirakataPapark 'test';
use HirakataPapark::DB::Row::Park;

use_ok 'HirakataPapark::Class::Point';

my $point;
lives_ok {
  $point = HirakataPapark::Class::Point->new(
    x => 135.5253887,
    y => 34.8340993,
  );
};

done_testing;

