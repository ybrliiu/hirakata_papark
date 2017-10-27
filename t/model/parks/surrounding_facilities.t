use HirakataPapark 'test';
use Test::HirakataPapark::PostgreSQL;
my $PSQL = Test::HirakataPapark::PostgreSQL->new;
use HirakataPapark::Model::Parks::SurroundingFacilities;
my $model = HirakataPapark::Model::Parks::SurroundingFacilities->new;
use Test::HirakataPapark::Model::Parks;
my $tester = Test::HirakataPapark::Model::Parks->new;
$tester->add_test_park;
    
subtest 'add_row' => sub {
  my $park = $tester->parks_model->get_row_by_name( $tester->TEST_PARK_PARMS->{name} )->get;
  lives_ok {
    $model->add_row({
      park_id      => $park->id,
      name         => '駐車場',
      english_name => 'Parking lot        ',
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
