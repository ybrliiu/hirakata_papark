use HirakataPapark 'test';
use Test::HirakataPapark::PostgreSQL;
my $PSQL = Test::HirakataPapark::PostgreSQL->new;
use HirakataPapark::Model::Parks::Plants;
my $model = HirakataPapark::Model::Parks::Plants->new;
use Test::HirakataPapark::Model::Parks;
my $tester = Test::HirakataPapark::Model::Parks->new;
$tester->add_test_park;
    
subtest 'add_row' => sub {
  my $park = $tester->parks_model->get_row_by_name( $tester->TEST_PARK_PARMS->{name} )->get;
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

subtest 'categoryzed_plants_list' => sub {
  my $categoryzed_plants_list;
  lives_ok { $categoryzed_plants_list = $model->get_categoryzed_plants_list };
  is_deeply $categoryzed_plants_list, +{'桜' => ['ソメイヨシノ']};
};

done_testing;
