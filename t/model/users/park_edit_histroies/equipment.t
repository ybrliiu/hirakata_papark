use Test::HirakataPapark;
use Test::HirakataPapark::Container;
use HirakataPapark::Model::Users::ParkEditHistories::Equipment;
use HirakataPapark::Model::Users::ParkEditHistories::Equipment::Equipment;
use HirakataPapark::Model::Users::ParkEditHistories::Equipment::LangRecord;
use HirakataPapark::Model::Users::ParkEditHistories::OneToMany::Item::ToAdd;
use HirakataPapark::Model::Users::ParkEditHistories::OneToMany::LangRecords;
use HirakataPapark::Model::Users::ParkEditHistories::OneToMany::History::ToAdd;

my $Equipment   = 'HirakataPapark::Model::Users::ParkEditHistories::Equipment::Equipment';
my $LangRecord  = 'HirakataPapark::Model::Users::ParkEditHistories::Equipment::LangRecord';
my $Item        = 'HirakataPapark::Model::Users::ParkEditHistories::OneToMany::Item::ToAdd';
my $LangRecords = 'HirakataPapark::Model::Users::ParkEditHistories::OneToMany::LangRecords';
my $History     = 'HirakataPapark::Model::Users::ParkEditHistories::OneToMany::History::ToAdd';

my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;
my $tc = $c->get_sub_container('TestData');
my $user = $tc->get_sub_container('User')->get_service('user')->get;
my $park = $tc->get_sub_container('Park')->get_service('park')->get;

my $model;
lives_ok {
  $model =
    HirakataPapark::Model::Users::ParkEditHistories::Equipment->new(db => $db);
};

my $history = $History->new(
  park_id           => $park->id,
  editer_seacret_id => $user->seacret_id,
  items             => [
    $Item->new(
      $Equipment->new(
        num             => 1,
        recommended_age => 0,
        lang_records    => $LangRecords->new(
          ja => $LangRecord->new(
            name    => '滑り台',
            comment => '',
          ),
          en => $LangRecord->new(
            name    => 'Suberidai',
            comment => '',
          ),
        ),
      ),
    ),
    $Item->new(
      $Equipment->new(
        num             => 3,
        recommended_age => 10,
        lang_records    => $LangRecords->new(
          ja => $LangRecord->new(
            name    => 'ブランコ',
            comment => 'ゆーらゆーら',
          ),
          en => $LangRecord->new(
            name    => 'Swing',
            comment => 'swing swing...',
          ),
        ),
      ),
    ),
  ],
);

subtest add_history => sub {
  my $result;
  lives_ok { $result = $model->add_history($history) };
  ok $result->is_right;
  $result->left->map(sub ($e) {
    diag $e;
  });
};

subtest get_histories_by_park_id => sub {
  my $histories;
  lives_ok { $histories = $model->get_histories_by_park_id($park->id, 1) };
  is_deeply [ map { $_->name } $histories->[0]->items->@* ], ['滑り台', 'ブランコ'];
};

subtest get_histories_by_user_seacret_id => sub {
  my $histories;
  lives_ok {
    $histories = $model->get_histories_by_user_seacret_id({
      num             => 2,
      lang            => 'en',
      user_seacret_id => $user->seacret_id,
    });
  };
  is_deeply [ map { $_->name } $histories->[0]->items->@* ], ['Suberidai', 'Swing'];
};

done_testing;
