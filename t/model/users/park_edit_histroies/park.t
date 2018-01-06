use Test::HirakataPapark;
use Test::HirakataPapark::Container;
use HirakataPapark::Model::Users::ParkEditHistories::Park;
use HirakataPapark::Model::Users::ParkEditHistories::Park::History::Add;
use HirakataPapark::Model::Users::ParkEditHistories::Park::DiffColumnSets;
use HirakataPapark::Model::Users::ParkEditHistories::Park::ForeignLangTableSets;

# alias
use constant {
  History => 
    'HirakataPapark::Model::Users::ParkEditHistories::Park::History::Add',
  DiffColumnSets =>
    'HirakataPapark::Model::Users::ParkEditHistories::Park::DiffColumnSets',
  ForeignLangTableSets =>
    'HirakataPapark::Model::Users::ParkEditHistories::Park::ForeignLangTableSets',
};

my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;
my $tc = $c->get_sub_container('TestData');
my $user = $tc->get_sub_container('User')->get_service('user')->get;
my $park = $tc->get_sub_container('Park')->get_service('park')->get;

my $model;
lives_ok {
  $model = HirakataPapark::Model::Users::ParkEditHistories::Park->new(db => $db);
};

subtest add_history => sub {
  my $sets = ForeignLangTableSets->new(
    ja => DiffColumnSets->new(
      park_name    => 'A公園',
      park_address => 'ahlfhkassa',
      park_explain => 'sedl;dskals',
    ),
    en => DiffColumnSets->new(
      park_name    => 'A Park',
      park_address => 'ahlfhkassa',
      park_explain => 'sedl;dskals',
    ),
  );
  my %params = map {
    my $name = $_;
    "park_$name" => $park->$name;
  } qw( id zipcode x y area is_evacuation_area );
  my $history = History->new(
    lang                    => 'ja',
    editer_seacret_id       => $user->seacret_id,
    foreign_lang_table_sets => $sets,
    %params,
  );
  lives_ok { $model->add_history($history) };
};

subtest get_histories_by_user_seacret_id => sub {
  my $result = $model->get_histories_by_user_seacret_id(
    lang            => 'ja', 
    num             => 10,
    user_seacret_id => $user->seacret_id, 
  );
  ok $result;
};

subtest get_histories_by_park_id => sub {
  my $result = $model->get_histories_by_park_id($park->id, 10);
  ok $result;
};

done_testing;
