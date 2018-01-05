use Test::HirakataPapark;
use Test::HirakataPapark::Container;
use HirakataPapark::Model::Parks::Stars;

my $c     = Test::HirakataPapark::Container->new;
my $db    = $c->get_sub_container('DB')->get_service('db')->get;
my $tc    = $c->get_sub_container('TestData');
my $user  = $tc->get_sub_container('User')->get_service('user')->get;
my $park  = $tc->get_sub_container('Park')->get_service('park')->get;
my $model = HirakataPapark::Model::Parks::Stars->new( db => $db );

subtest 'add_row' => sub {
  my $param = {
    park_id         => $park->id,
    user_seacret_id => $user->seacret_id,
  };
  lives_ok { $model->add_row($param) };
  dies_ok { $model->add_row($param) };
};

subtest 'get_lists' => sub {
  my $star = $model->get_rows_by_park_id($park->id);
  is @$star, 1;
  $star = $model->get_rows_by_user_seacret_id($user->seacret_id);
  is @$star, 1;
};

done_testing;
