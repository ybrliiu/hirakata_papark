use Test::HirakataPapark;

use Test::HirakataPapark::Container;
my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;

use HirakataPapark::Model::Parks::Equipments;
my $model = HirakataPapark::Model::Parks::Equipments->new(db => $db);
    
subtest 'add_row' => sub {
  my $park = $c->get_sub_container('TestData')->get_sub_container('Park')->get_service('park')->get;
  lives_ok {
    $model->add_row({
      park_id      => $park->id,
      name         => 'ブランコ',
    });
    $model->add_row({
      park_id      => $park->id,
      name         => '鉄棒',
    });
  };
  my @equipments = $model->get_rows_by_name('ブランコ')->@*;
  is @equipments, 1;
  # relation ship test
  is $equipments[0]->park->name, $park->name;
};

subtest 'get_rows_by_names' => sub {
  my $rows = $model->get_rows_by_names([qw/ブランコ 鉄棒/]);
  is @$rows, 2;
};

subtest 'get_park_id_list_has_names' => sub {
  lives_ok {
    my $id_list = $model->get_park_id_list_has_names([qw/ブランコ 鉄棒/]);
    is_deeply $id_list, [1];
  };
};

done_testing;
