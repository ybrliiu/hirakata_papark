use HirakataPapark 'test';
use Test::HirakataPapark::Container;

my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;
my $tc = $c->get_sub_container('TestData')->get_sub_container('Park');

use HirakataPapark::Model::Parks::EnglishParks;
my $model = HirakataPapark::Model::Parks::EnglishParks->new(db => $db);

subtest add_row => sub {
  my $jpark = $tc->get_service('park')->get;
  lives_ok {
    $model->add_row({
      id      => $jpark->id,
      name    => 'Hoge Park',
      address => '20 B town A City',
    });
  };
  ok my $park = $model->get_row_by_name('Hoge Park')->get;
  is $park->name, 'Hoge Park';
  is $park->area, $jpark->area;
};

subtest add_rows => sub {
  my ($jpark2, $jpark3) = map { $tc->get_service($_)->get } qw/ park2 park3 /;

  dies_ok {
    $model->add_rows([
      {
        id      => 20,
        name    => 'B Park',
        address => 'A city hogehoge',
      },
      {
        id      => 30,
        name    => 'C Park',
        address => 'A???',
      },
    ]);
  };

  lives_ok {
    $model->add_rows([
      {
        id      => $jpark2->id,
        name    => 'Zonohana Park',
        address => 'A City C - 10000',
      },
      {
        id      => $jpark3->id,
        name    => 'Akichi Park',
        address => '1_B A City',
      },
    ]);
  };

  my $rows = $model->get_rows_all;
  is scalar @$rows, 3;
  is $rows->to_json_for_marker, '[ { "id": 1, "name": "Hoge Park", "x": 0, "y": 1.303 }, { "id": 2, "name": "Zonohana Park", "x": 111, "y": 13.303 }, { "id": 3, "name": "Akichi Park", "x": 30, "y": 111.303 } ]';
};

subtest get_row => sub {
  lives_ok { $model->get_row_by_id(1)->get };
  lives_ok { $model->get_row_by_name('Zonohana Park')->get };
  lives_ok { $model->get_rows_by_id_list([1, 2]) };
};

subtest get_rows_like_name => sub {
  my $parks;
  lives_ok { $parks = $model->get_rows_like_name('Park') };
  is @$parks, 3;
};

subtest get_rows_like_address => sub {
  my $parks;
  lives_ok { $parks = $model->get_rows_like_address('A City') };
  is @$parks, 3;
};

done_testing;

