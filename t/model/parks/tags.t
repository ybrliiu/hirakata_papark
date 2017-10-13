use HirakataPapark 'test';
use Test::HirakataPapark::PostgreSQL;
my $PSQL = Test::HirakataPapark::PostgreSQL->new;
use HirakataPapark::Model::Parks::Tags;
my $model = HirakataPapark::Model::Parks::Tags->new;
use Test::HirakataPapark::Model::Parks;
my $tester = Test::HirakataPapark::Model::Parks->new;
$tester->add_test_park;
    
subtest 'add_row' => sub {
  my $park = $tester->parks_model->get_row_by_name( $tester->TEST_PARK_PARMS->{name} )->get;
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
