use HirakataPapark 'test';
use Test::HirakataPapark::Container;
use HirakataPapark::Model::Users;

my $c     = Test::HirakataPapark::Container->new;
my $db    = $c->get_sub_container('DB')->get_service('db')->get;
my $model = HirakataPapark::Model::Users->new(db => $db);

my $param = {
  id       => 'test_user',
  name     => 'テストユーザー',
  password => 'hogehoge...',
};

lives_ok { $model->add_row($param) };
$model->get_row_by_id('test_user')->map(sub { is $_->name, 'テストユーザー' });
$model->get_row_by_name('テストユーザー')->map(sub { is $_->id, 'test_user' });

done_testing;

