use HirakataPapark 'test';
use Test::HirakataPapark::PostgreSQL;
my $PSQL = Test::HirakataPapark::PostgreSQL->new;

use HirakataPapark::Model::Parks::Tags;
my $model = HirakataPapark::Model::Parks::Tags->new;

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
      park_id => $park->id,
      name    => '遊びやすい',
    });
  };
  my @equipments = $model->get_rows_by_name('遊びやすい')->@*;
  is @equipments, 1;
};

subtest 'get_tag_list' => sub {
  ok my $tag_list = $model->get_tag_list;
  diag explain $tag_list;
};

done_testing;
