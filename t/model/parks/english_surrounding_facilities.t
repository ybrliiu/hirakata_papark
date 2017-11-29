use HirakataPapark 'test';

use Test::HirakataPapark::Container;
my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;
my $tc = $c->get_sub_container('TestData')->get_sub_container('Park');

use HirakataPapark::Model::Parks::EnglishSurroundingFacilities;
my $model = HirakataPapark::Model::Parks::EnglishSurroundingFacilities->new(db => $db);

subtest 'add_row' => sub {
  my $epark = $tc->get_service('english_park')->get;
  my $sc    = $tc->get_service('surrounding_facility')->get;
  lives_ok {
    $model->add_row({
      id      => $sc->id,     
      park_id => $epark->id,
      name    => 'Parking',
    });
  };
  my @equipments = $model->get_rows_by_name('Parking')->@*;
  is @equipments, 1;
};

subtest 'get_lists' => sub {
  ok my $category_list = $model->get_surrounding_facility_list;
  is $category_list->[0], 'Parking';
};

done_testing;
