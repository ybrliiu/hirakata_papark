use HirakataPapark 'test';

use Test::HirakataPapark::Container;
my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;
my $tc = $c->get_sub_container('TestData')->get_sub_container('Park');

use HirakataPapark::Model::Parks::EnglishEquipments;
my $model = HirakataPapark::Model::Parks::EnglishEquipments->new(db => $db);
my $epark = $tc->get_service('english_park')->get;
    
subtest 'add_row' => sub {
  my $eq1 = $tc->get_service('equipment')->get;
  my $eq2 = $tc->get_service('equipment2')->get;

  lives_ok {
    $model->add_row({
      id      => $eq1->id,
      park_id => $eq1->park_id,
      name    => 'Swing',
    });
    $model->add_row({
      id      => $eq2->id,
      park_id => $eq2->park_id,
      name    => 'Horizontal Bar',
    });
  };
  my @equipments = $model->get_rows_by_name('Swing')->@*;
  is @equipments, 1;
};

subtest 'get_rows_by_names' => sub {
  diag $model->PREFETCH_TABLE_NAME;
  my $rows = $model->get_rows_by_names(['Swing', 'Horizontal Bar']);
  is @$rows, 2;
  $rows = $model->get_rows_by_names_with_prefetch(['Horizontal Bar']);
  is @$rows, 1;
  is $rows->[0]->park->name, $epark->name;
};

subtest 'get_park_id_list_has_names' => sub {
  my $id_list;
  lives_ok { $id_list = $model->get_park_id_list_has_names(['Horizontal Bar']) };
  is_deeply $id_list, [1];
};

done_testing;
