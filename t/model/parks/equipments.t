use HirakataPapark 'test';
use Test::HirakataPapark::PostgreSQL;
my $PSQL = Test::HirakataPapark::PostgreSQL->new;
use HirakataPapark::Model::Parks::Equipments;
my $model = HirakataPapark::Model::Parks::Equipments->new;
use Test::HirakataPapark::Model::Parks;
my $tester = Test::HirakataPapark::Model::Parks->new;
$tester->add_test_park;
    
subtest 'add_row' => sub {
  my $park = $tester->parks_model->get_row_by_name( $tester->TEST_PARK_PARMS->{name} )->get;
  lives_ok {
    $model->add_row({
      park_id      => $park->id,
      name         => 'ブランコ',
      english_name => 'swing',
    });
    $model->add_row({
      park_id      => $park->id,
      name         => '鉄棒',
      english_name => 'Iron bar',
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
  is @$rows, 2;
  $rows = $model->get_rows_by_names_with_prefetch([qw/ブランコ 鉄棒/]);
  is @$rows, 2;
};

subtest 'get_park_id_list_has_names' => sub {
  lives_ok {
    my $id_list = $model->get_park_id_list_has_names([qw/ブランコ 鉄棒/]);
    diag explain $id_list;
  };
};

done_testing;
