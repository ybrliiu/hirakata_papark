use Test::HirakataPapark;
use Test::HirakataPapark::Container;
use HirakataPapark::Model::Users::ParkEditHistories::Park;
use HirakataPapark::Model::Users::ParkEditHistories::Park::LangRecord;
use HirakataPapark::Model::Users::ParkEditHistories::History::LangRecords;
use HirakataPapark::Model::Users::ParkEditHistories::Park::Park;
use HirakataPapark::Model::Users::ParkEditHistories::History::History::HasOne::ToAdd;

my $Park   = 'HirakataPapark::Model::Users::ParkEditHistories::Park::Park';
my $LangRecord  = 'HirakataPapark::Model::Users::ParkEditHistories::Park::LangRecord';
my $LangRecords = 'HirakataPapark::Model::Users::ParkEditHistories::History::LangRecords';
my $History     = 'HirakataPapark::Model::Users::ParkEditHistories::History::History::HasOne::ToAdd';

my $c = Test::HirakataPapark::Container->new;
my $db = $c->fetch('DB/db')->get;
my $user = $c->fetch('TestData/User/user')->get;
my $park = $c->fetch('TestData/Park/park')->get;

my $model;
lives_ok {
  $model = HirakataPapark::Model::Users::ParkEditHistories::Park->new(db => $db);
};

subtest add_history => sub {
  my $history = $History->new(
    park_id           => 1,
    editer_seacret_id => 1,
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
  my $result;
  lives_ok { $result = $model->add_history($history) };
  ok $result->is_right;
  $result->left->map(sub ($e) {
    diag $e;
  });
};

subtest get_histories_by_user_seacret_id => sub {
  my $result = $model->get_histories_by_user_seacret_id(
    lang            => 'en', 
    num             => 10,
    user_seacret_id => $user->seacret_id, 
  );
  is $result->[0]->name, 'Zonohana Park';
};

subtest get_histories_by_park_id => sub {
  my $result = $model->get_histories_by_park_id($park->id, 10);
  is $result->[0]->name, 'ぞのはなこうえん';
};

done_testing;
