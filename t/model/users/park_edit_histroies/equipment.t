use Test::HirakataPapark;
use Test::HirakataPapark::Container;
use HirakataPapark::Model::Users::ParkEditHistories::Equipment;
use HirakataPapark::Model::Users::ParkEditHistories::Equipment::HistoryToAdd::LangRecord;
use HirakataPapark::Model::Users::ParkEditHistories::Equipment::HistoryToAdd::LangRecords;
use HirakataPapark::Model::Users::ParkEditHistories::Equipment::HistoryToAdd::Equipment;
use HirakataPapark::Model::Users::ParkEditHistories::Equipment::HistoryToAdd::History;

# alias
use constant {
  LangRecord =>
    'HirakataPapark::Model::Users::ParkEditHistories::Equipment::HistoryToAdd::LangRecord',
  LangRecords =>
    'HirakataPapark::Model::Users::ParkEditHistories::Equipment::HistoryToAdd::LangRecords',
  Equipment =>
    'HirakataPapark::Model::Users::ParkEditHistories::Equipment::HistoryToAdd::Equipment',
  History =>
    'HirakataPapark::Model::Users::ParkEditHistories::Equipment::HistoryToAdd::History',
};

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

my $history = History->new(
  park_id           => $park->id,
  editer_seacret_id => $user->seacret_id,
  equipments        => [
    Equipment->new(
      num             => 3,
      recommended_age => 10,
      lang_records    => LangRecords->new(
        ja => LangRecord->new(
          name => 'ブランコ',
          comment => 'ゆーらゆーら',
        ),
        en => LangRecord->new(
          name => 'Swing',
          comment => 'swing swing...',
        ),
      ),
    ),
  ],
);

subtest add_history => sub {
  my $result;
  lives_ok { $result = $model->add_history($history) };
  ok $result->is_right;
};

done_testing;
