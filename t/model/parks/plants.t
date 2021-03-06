use Test::HirakataPapark;

use Test::HirakataPapark::Container;
my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;

use HirakataPapark::Model::Parks::Plants;
my $model = HirakataPapark::Model::Parks::Plants->new(db => $db);

subtest 'add_row' => sub {
  my $park = $c->get_sub_container('TestData')->get_sub_container('Park')->get_service('park')->get;
  lives_ok {
    $model->add_row({
      park_id  => $park->id,
      name     => 'ソメイヨシノ',
      category => '桜',
    });
  };
  my @equipments = $model->get_rows_by_name('ソメイヨシノ')->@*;
  is @equipments, 1;

  @equipments = $model->get_rows_by_category('桜')->@*;
  is @equipments, 1;

  ok my @park_category_list = $model->get_categories_by_park_id($park->id)->@*;
  is $park_category_list[0], '桜';
};

subtest 'get_lists' => sub {
  ok my $category_list = $model->get_categories;
  is $category_list->[0], '桜';
  ok my $plants_list = $model->get_plants_list;
  is $plants_list->[0], 'ソメイヨシノ';
  my $rows = $model->get_all_distinct_rows([qw/ category name /]);
  is @$rows[0]->name, 'ソメイヨシノ';
};

done_testing;
