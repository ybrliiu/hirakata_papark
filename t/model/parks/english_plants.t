use HirakataPapark 'test';

use Test::HirakataPapark::Container;
my $c = Test::HirakataPapark::Container->new;
my $tc = $c->get_sub_container('TestData')->get_sub_container('Park');
my $db = $c->get_sub_container('DB')->get_service('db')->get;

use HirakataPapark::Model::Parks::EnglishPlants;
my $model = HirakataPapark::Model::Parks::EnglishPlants->new(db => $db);

subtest 'add_row' => sub {
  my $epark  = $tc->get_service('english_park')->get;
  my $plants = $tc->get_service('plants')->get;
  lives_ok {
    $model->add_row({
      id       => $plants->id,
      park_id  => $epark->id,
      name     => 'SomeiYoshino',
      category => 'cherry blossom',
    });
  };
  my @equipments = $model->get_rows_by_name('SomeiYoshino')->@*;
  is @equipments, 1;

  @equipments = $model->get_rows_by_category('cherry blossom')->@*;
  is @equipments, 1;

  ok my @park_category_list = $model->get_categories_by_park_id($epark->id)->@*;
  is $park_category_list[0], 'cherry blossom';
};

subtest 'get_lists' => sub {
  ok my $category_list = $model->get_categories;
  is $category_list->[0], 'cherry blossom';
  ok my $plants_list = $model->get_plants_list;
  is $plants_list->[0], 'SomeiYoshino';
  my $rows = $model->get_all_distinct_rows([qw/ category name /]);
  is @$rows[0]->name, 'SomeiYoshino';
};

done_testing;
