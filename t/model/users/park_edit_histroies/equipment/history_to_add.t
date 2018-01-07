use Test::HirakataPapark;
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

my $lang_record = LangRecord->new({
  name    => 'ブランコ',
  comment => 'ぶらぶあ',
});

subtest has_all => sub {
  my $lang_records = LangRecords->new(
    ja => $lang_record,
    en => $lang_record,
  );
  my $equipment = Equipment->new(
    lang            => 'ja',
    recommended_age => 10,
    num             => 3,
    lang_records    => $lang_records,
  );
  my $history = History->new(
    park_id           => 0,
    editer_seacret_id => 0,
    equipments        => [$equipment],
  );
  ok $history->has_all;
};

done_testing;
