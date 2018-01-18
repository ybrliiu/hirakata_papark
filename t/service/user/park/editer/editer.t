use Test::HirakataPapark;
use Test::HirakataPapark::Container;
use aliased 'HirakataPapark::Service::User::Park::Editer::Editer';

my $c                     = Test::HirakataPapark::Container->new;
my $db                    = $c->fetch('DB/db')->get;
my $user                  = $c->fetch('TestData/User/user')->get;
my $park                  = $c->fetch('TestData/Park/park')->get;
my $edit_histories_model  = $c->fetch('Model/Users/park_edit_histories')->get;
my $parks_model_delegator = $c->fetch('Model/MultilingualDelegator/parks')->get;

subtest success_case => sub {
  my $editer = Editer->new(
    db   => $db,
    lang => 'ja',
    user => $user,
    json => {
      park_id            => $park->id,
      x                  => 0,
      y                  => 0,
      area               => 0,
      zipcode            => '111-1111',
      is_evacuation_area => 0,
      ja => {
        name    => 'AA公園',
        address => '大阪府枚方市ほげほげ町1-1-1',
        explain => '楽しいよ！',
      },
      en => {
        name    => 'AA公園',
        address => '大阪府枚方市ほげほげ町1-1-1',
        explain => '楽しいよ！',
      },
    },
    histories_model       => $edit_histories_model,
    parks_model_delegator => $parks_model_delegator,
  );
  my $result;
  $SIG{__DIE__} = \&Carp::confess;
  lives_ok { $result = $editer->edit };
  ok $result->is_right;
  $result->left->map(sub ($e) {
    diag explain $e;
  });
};

subtest error_case => sub {
  my $editer = Editer->new(
    db                    => $db,
    lang                  => 'ja',
    user                  => $user,
    json                  => {},
    histories_model       => $edit_histories_model,
    parks_model_delegator => $parks_model_delegator,
  );
  my $result;
  lives_ok { $result = $editer->edit };
  ok $result->is_left;
};

done_testing;
