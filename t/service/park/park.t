use HirakataPapark 'test';
use Test::HirakataPapark::Container;
use HirakataPapark::Service::Park::Park;

my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;
my $mc = $c->get_sub_container('Model')->get_sub_container('Parks');
my $row = $c->get_sub_container('TestData')->get_sub_container('Park')->get_service('park')->get;
my $park;

lives_ok {
  $park = HirakataPapark::Service::Park::Park->new(
    row             => $row,
    park_tags       => $mc->get_service('tags')->get,
    park_stars      => $mc->get_service('stars')->get,
    park_plants     => $mc->get_service('plants')->get,
    park_images     => $mc->get_service('images')->get,
    park_equipments => $mc->get_service('equipments')->get,
    park_facilities => $mc->get_service('surrounding_facilities')->get,
  )
};
lives_ok { $park->tags };
lives_ok { $park->stars };
is $park->stars->len, 0;
lives_ok { $park->plants };
lives_ok { $park->images };
lives_ok { $park->plants_categories };
lives_ok { $park->surrounding_facility_names };
is $park->size, '大';

done_testing;
