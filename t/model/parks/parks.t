use HirakataPapark 'test';
use Test::HirakataPapark::Container;

my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;

use HirakataPapark::Model::Parks::Parks;
my $model = HirakataPapark::Model::Parks::Parks->new(db => $db);

subtest add_row => sub {
  lives_ok {
    $model->add_row({
      name              => 'ほげ公園',
      address           => 'A市B町20',
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
        address         => 'A市B町20',
        x               => 0.0000,
        y               => 1.3030,
        area            => 1000
      },
      {
        name            => 'C公園',
        address         => 'A市B町20',
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

subtest get_row => sub {
  lives_ok { $model->get_row_by_id(1)->get };
  lives_ok { $model->get_row_by_name('ほげ公園')->get };
  lives_ok { $model->get_rows_by_id_list([1, 2]) };
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
