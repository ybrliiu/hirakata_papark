use Test::HirakataPapark;
use HirakataPapark::Model::Users::ParkEditHistories::Equipment::Equipment;
use HirakataPapark::Model::Users::ParkEditHistories::Equipment::LangRecord;
use HirakataPapark::Model::Users::ParkEditHistories::History::Item::ToAdd;
use HirakataPapark::Model::Users::ParkEditHistories::History::LangRecords;
use HirakataPapark::Model::Users::ParkEditHistories::History::History::HasMany::ToAdd;

my $Equipment   = 'HirakataPapark::Model::Users::ParkEditHistories::Equipment::Equipment';
my $LangRecord  = 'HirakataPapark::Model::Users::ParkEditHistories::Equipment::LangRecord';
my $Item        = 'HirakataPapark::Model::Users::ParkEditHistories::History::Item::ToAdd';
my $LangRecords = 'HirakataPapark::Model::Users::ParkEditHistories::History::LangRecords';
my $History     = 'HirakataPapark::Model::Users::ParkEditHistories::History::History::HasMany::ToAdd';

subtest has_all => sub {
  my $history = $History->new(
    park_id           => 0,
    editer_seacret_id => 0,
    items             => [
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
  ok $history->has_all;
  is $history->items->[0]->name, 'ブランコ';
  lives_ok { $history->to_params };
  is_deeply $history->items_to_params(3), [{
    history_id                => 3,
    equipment_num             => 3,
    equipment_name            => 'ブランコ',
    equipment_comment         => 'ゆーらゆーら',
    equipment_recommended_age => 10,
  }];
  is_deeply $history->items_lang_record_to_params('en', 3), [{
    history_id        => 3,
    equipment_name    => 'Swing',
    equipment_comment => 'swing swing...',
  }];
};

done_testing;
