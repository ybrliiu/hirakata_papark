use Test::HirakataPapark;
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
  diag explain $history->to_params;
  diag explain $history->items_to_params(3);
  diag explain $history->items_lang_records_to_params_by_lang('ja', 3);
};

done_testing;
