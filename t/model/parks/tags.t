use HirakataPapark 'test';

use Test::HirakataPapark::Container;
my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;

use HirakataPapark::Model::Parks::Parks::Tags;
my $model = HirakataPapark::Model::Parks::Parks::Tags->new(db => $db);

subtest 'add_row' => sub {
  my $park = $c->get_sub_container('TestData')->get_sub_container('Park')->get_service('park')->get;
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
