use HirakataPapark 'test';
use Test::HirakataPapark::PostgreSQL;
my $PSQL = Test::HirakataPapark::PostgreSQL->new;

use HirakataPapark::Model::Parks::SurroundingFacilities;
my $model = HirakataPapark::Model::Parks::SurroundingFacilities->new;

use HirakataPapark::Model::Parks;
my $parks_model = HirakataPapark::Model::Parks->new;

# init
do {
  $parks_model->add_row({
    name    => 'ほげ公園',
    address => 'A市B町20',
    x       => 0.0000,
    y       => 1.3030,
    area    => 1000
  });
};  
    
subtest 'add_row' => sub {
  my $park = $parks_model->get_row_by_name('ほげ公園')->get;
  lives_ok {
    $model->add_row({
      park_id  => $park->id,
      name     => '駐車場',
    });
  };
  my @equipments = $model->get_rows_by_name('駐車場')->@*;
  is @equipments, 1;
};

subtest 'get_lists' => sub {
  ok my $category_list = $model->get_facility_list;
  is $category_list->[0], '駐車場';
};

done_testing;
