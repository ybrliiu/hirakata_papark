use HirakataPapark 'test';
use Test::HirakataPapark::PostgreSQL;
my $PSQL = Test::HirakataPapark::PostgreSQL->new;

use HirakataPapark::Model::Parks::Plants;
my $model = HirakataPapark::Model::Parks::Plants->new;

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
      category => '桜',
      name     => 'ソメイヨシノ',
    });
  };
  my @equipments = $model->get_rows_by_name('ソメイヨシノ')->@*;
  is @equipments, 1;

  @equipments = $model->get_rows_by_category('桜')->@*;
  is @equipments, 1;

  ok my @park_category_list = $model->get_category_list_by_park_id($park->id)->@*;
  is $park_category_list[0], '桜';
};

subtest 'get_lists' => sub {
  ok my $category_list = $model->get_category_list;
  is $category_list->[0], '桜';
  ok my $plants_list = $model->get_plants_list;
  is $plants_list->[0], 'ソメイヨシノ';
};

done_testing;
