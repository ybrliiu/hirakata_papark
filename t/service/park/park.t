use HirakataPapark 'test';
use HirakataPapark 'test';

use Test::HirakataPapark::Container;
my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;

use HirakataPapark::Model::Parks::Parks::Plants;
use HirakataPapark::Model::Parks::Parks::SurroundingFacilities;
use HirakataPapark::Service::Park::Park;

my $row = $c->get_sub_container('TestData')->get_sub_container('Park')->get_service('park')->get;
ok(
  my $park = HirakataPapark::Service::Park::Park->new(
    row             => $row,
    park_plants     => HirakataPapark::Model::Parks::Parks::Plants->new(db => $db),
    park_facilities => HirakataPapark::Model::Parks::Parks::SurroundingFacilities->new(db => $db),
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
