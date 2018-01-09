use Test::HirakataPapark;
use Test::HirakataPapark::Container;
use HirakataPapark::Model::Users::ParkEditHistories::Plants;
use HirakataPapark::Model::Users::ParkEditHistories::Plants::Plants;
use HirakataPapark::Model::Users::ParkEditHistories::Plants::LangRecord;
use HirakataPapark::Model::Users::ParkEditHistories::History::Item::ToAdd;
use HirakataPapark::Model::Users::ParkEditHistories::History::LangRecords;
use HirakataPapark::Model::Users::ParkEditHistories::History::History::HasMany::ToAdd;

my $Plants   = 'HirakataPapark::Model::Users::ParkEditHistories::Plants::Plants';
my $LangRecord  = 'HirakataPapark::Model::Users::ParkEditHistories::Plants::LangRecord';
my $Item        = 'HirakataPapark::Model::Users::ParkEditHistories::History::Item::ToAdd';
my $LangRecords = 'HirakataPapark::Model::Users::ParkEditHistories::History::LangRecords';
my $History     = 'HirakataPapark::Model::Users::ParkEditHistories::History::History::HasMany::ToAdd';

my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;
my $tc = $c->get_sub_container('TestData');
my $user = $tc->get_sub_container('User')->get_service('user')->get;
my $park = $tc->get_sub_container('Park')->get_service('park')->get;

my $model;
lives_ok {
  $model =
    HirakataPapark::Model::Users::ParkEditHistories::Plants->new(db => $db);
};

my $history = $History->new(
  park_id           => $park->id,
  editer_seacret_id => $user->seacret_id,
  items             => [
    $Item->new(
      $Plants->new(
        num          => 1,
        lang_records => $LangRecords->new(
          ja => $LangRecord->new(
            name     => 'ソメイヨシノ',
            category => '桜',
            comment  => '',
          ),
          en => $LangRecord->new(
            name     => 'Yoshino Cherry',
            category => 'Cherry Browwom',
            comment  => '',
          ),
        ),
      ),
    ),
    $Item->new(
      $Plants->new(
        num          => 3,
        lang_records => $LangRecords->new(
          ja => $LangRecord->new(
            name     => 'バラ',
            category => '花',
            comment  => 'ゆーらゆーら',
          ),
          en => $LangRecord->new(
            name     => 'Bara?',
            category => 'Flower',
            comment  => 'swing swing...',
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
  is_deeply [ map { $_->name } $histories->[0]->items->@* ], ['バラ', 'ソメイヨシノ'];
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
  is_deeply [ map { $_->name } $histories->[0]->items->@* ], ['Yoshino Cherry', 'Bara?'];
};

done_testing;
