use HirakataPapark 'test';
use Test::HirakataPapark::PostgreSQL;
my $PSQL = Test::HirakataPapark::PostgreSQL->new;

use HirakataPapark::Model::Parks;
my $model = HirakataPapark::Model::Parks->new;

subtest add_row => sub {
  lives_ok {
    $model->add_row({
      name         => 'ほげ公園',
      addres       => 'A市B町20',
      x_coordinate => 0.0000,
      y_coordinate => 1.3030,
      area         => 1000
    });
  };
  ok my $park = $model->get_row_by_name('ほげ公園')->get;
  is $park->name, 'ほげ公園';
  is $park->area, 1000;
};

subtest add_rows => sub {
  lives_ok {
    $model->add_rows([
      {
        name         => 'B公園',
        addres       => 'A市B町20',
        x_coordinate => 0.0000,
        y_coordinate => 1.3030,
        area         => 1000
      },
      {
        name         => 'C公園',
        addres       => 'A市B町20',
        x_coordinate => 0.0000,
        y_coordinate => 1.3030,
        area         => 1000
      },
    ])
  };
  my @rows = $model->get_rows_all;
  is scalar @rows, 3;
};

done_testing;

