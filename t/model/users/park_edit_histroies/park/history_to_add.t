use Test::HirakataPapark;
use HirakataPapark::Model::Users::ParkEditHistories::Park::LangRecord;
use HirakataPapark::Model::Users::ParkEditHistories::History::LangRecords;
use HirakataPapark::Model::Users::ParkEditHistories::Park::Park;
use HirakataPapark::Model::Users::ParkEditHistories::History::History::HasOne::ToAdd;

my $Park   = 'HirakataPapark::Model::Users::ParkEditHistories::Park::Park';
my $LangRecord  = 'HirakataPapark::Model::Users::ParkEditHistories::Park::LangRecord';
my $LangRecords = 'HirakataPapark::Model::Users::ParkEditHistories::History::LangRecords';
my $History     = 'HirakataPapark::Model::Users::ParkEditHistories::History::History::HasOne::ToAdd';

subtest has_all => sub {
  my $history = $History->new(
    park_id           => 1,
    editer_seacret_id => 1,
    edited_time       => 0,
    item_impl => $Park->new(
      x       => 1,
      y       => 2,
      area    => 1000,
      zipcode => '661-0031',
      is_evacuation_area => 0,
      lang_records => $LangRecords->new(
        ja => $LangRecord->new(
          name    => 'ぞのはなこうえん',
          address => 'A市B町',
          explain => '',
        ),
        en => $LangRecord->new(
          name    => 'Zonohana Park',
          address => 'B town A city',
          explain => '',
        ),
      ),
    ),
  );
  ok $history->has_all;
  is_deeply $history->to_params, {
    park_id                   => 1,
    editer_seacret_id         => 1,
    edited_time               => 0,
    park_address              => 'A市B町',
    park_area                 => 1000,
    park_explain              => '',
    park_is_evacuation_area   => 0,
    park_name                 => 'ぞのはなこうえん',
    park_x                    => 1,
    park_y                    => 2,
    park_zipcode              => '661-0031',
  };
  is $history->name, 'ぞのはなこうえん';
};

done_testing;
