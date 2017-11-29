use HirakataPapark 'test';

use Test::HirakataPapark::Container;
my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;

use HirakataPapark::Model::Parks::SurroundingFacilities;
my $model = HirakataPapark::Model::Parks::SurroundingFacilities->new(db => $db);

subtest 'add_row' => sub {
  my $park = $c->get_sub_container('TestData')->get_sub_container('Park')->get_service('park')->get;
  lives_ok {
    $model->add_row({
      park_id      => $park->id,
      name         => '駐車場',
    });
  };
  my @equipments = $model->get_rows_by_name('駐車場')->@*;
  is @equipments, 1;
};

subtest 'get_lists' => sub {
  ok my $category_list = $model->get_surrounding_facility_list;
  is $category_list->[0], '駐車場';
};

done_testing;
