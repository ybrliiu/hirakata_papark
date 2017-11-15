use HirakataPapark 'test';
use Test::HirakataPapark::PostgreSQL;
use Test::HirakataPapark::Model::Parks;

my $psql = Test::HirakataPapark::PostgreSQL->new;
my $tester = Test::HirakataPapark::Model::Parks->new;
$tester->add_test_park();

use HirakataPapark::Model::Parks::Plants;
use HirakataPapark::Model::Parks::SurroundingFacilities;
use HirakataPapark::Service::Park::Park;

my $row = $tester->get_test_park();
ok(
  my $park = HirakataPapark::Service::Park::Park->new(
    row             => $row,
    park_plants     => HirakataPapark::Model::Parks::Plants->new,
    park_facilities => HirakataPapark::Model::Parks::SurroundingFacilities->new,
  )
);

lives_ok { $park->plants };
lives_ok { $park->plants_categories };
lives_ok { $park->plants_english_categories };
lives_ok { $park->surrounding_facility_names };
lives_ok { $park->surrounding_facility_english_names };
is $park->size, '大';
is $park->english_size, 'Wide';

done_testing;
