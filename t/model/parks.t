use HirakataPapark 'test';
use Test::HirakataPapark::PostgreSQL;
my $PSQL = Test::HirakataPapark::PostgreSQL->new;

use HirakataPapark::Model::Parks;
my $model = HirakataPapark::Model::Parks->new;

subtest add_row => sub {
  lives_ok {
    $model->add_row({
      name              => 'ほげ公園',
      english_name      => 'hoge park',
      address           => 'A市B町20',
      english_address   => '20, bmachi, a-shi',
      x                 => 0.0000,
      y                 => 1.3030,
      area              => 1000
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
        name            => 'B公園',
        english_name    => 'b park',
        address         => 'A市B町20',
        english_address => '20, bmachi, a-shi',
        x               => 0.0000,
        y               => 1.3030,
        area            => 1000
      },
      {
        name            => 'C公園',
        english_name    => 'c park',
        address         => 'A市B町20',
        english_address => '20, bmachi, a-shi',
        x               => 0.0000,
        y               => 1.3030,
        area            => 1000
      },
    ]);
  };
  my $rows = $model->get_rows_all;
  is scalar @$rows, 3;
  is $rows->to_json_for_marker, '[ { "id": 1, "name": "ほげ公園", "x": 0, "y": 1.303 }, { "id": 2, "name": "B公園", "x": 0, "y": 1.303 }, { "id": 3, "name": "C公園", "x": 0, "y": 1.303 } ]';
};

subtest get_rows_like_name => sub {
  my $parks;
  lives_ok { $parks = $model->get_rows_like_name('公園') };
  is $parks->@*, 3;
};

subtest get_rows_like_address => sub {
  my $parks;
  lives_ok { $parks = $model->get_rows_like_address('A市') };
  is $parks->@*, 3;
};

done_testing;

