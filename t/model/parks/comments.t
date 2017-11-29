use HirakataPapark 'test';

use Test::HirakataPapark::Container;
my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;

use HirakataPapark::Model::Parks::Comments;
my $model = HirakataPapark::Model::Parks::Comments->new(db => $db);
    
subtest 'add_row' => sub {
  my $park = $c->get_sub_container('TestData')->get_sub_container('Park')->get_service('park')->get;
  lives_ok {
    $model->add_row({
      park_id => $park->id,
      name    => 'マダム',
      message => '非常に美しい公園です.',
    });
    $model->add_row({
      park_id => $park->id,
      name    => '市民',
      message => '落書きが多いです...',
    });
    $model->add_row({
      park_id => $park->id,
      message => 'イリヤたそーーーーーーーーーーーー！！！',
    });
  };
  my $rows = $model->get_rows_by_park_id($park->id, 5);
  is @$rows, 3;
};

done_testing;
