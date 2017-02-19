use HirakataPapark 'test';
use Test::HirakataPapark::PostgreSQL;
my $PSQL = Test::HirakataPapark::PostgreSQL->new;

use HirakataPapark::Model::Parks::Equipments;
my $model = HirakataPapark::Model::Parks::Equipments->new;

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
      name    => 'ブランコ',
    });
    $model->add_row({
      park_id => $park->id,
      name    => '鉄棒',
    });
  };
  my @equipments = $model->get_rows_by_name('ブランコ')->@*;
  is @equipments, 1;
  # relation ship test
  diag $equipments[0]->park->name;
  # diag explain [$park->park_equipments];
};

subtest 'get_rows_by_names' => sub {
  my $rows = $model->get_rows_by_names([qw/ブランコ 鉄棒/]);
  diag explain $rows;
  ok 1;
};

done_testing;
