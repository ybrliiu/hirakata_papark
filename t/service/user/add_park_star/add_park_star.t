use HirakataPapark 'test';
use Test::HirakataPapark::Container;
use HirakataPapark::Service::User::AddParkStar::AddParkStar;

my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;
my $tc = $c->get_sub_container('TestData');
my $user = $tc->get_sub_container('User')->get_service('user')->get;
my $park = $tc->get_sub_container('Park')->get_service('park')->get;
my $park_stars = $c->get_sub_container('Model')->get_sub_container('Parks')->get_service('stars')->get;

subtest 'success_case' => sub {
  my $service = HirakataPapark::Service::User::AddParkStar::AddParkStar->new(
    db         => $db,
    lang       => 'ja',
    user       => $user,
    params     => HirakataPapark::Validator::Params->new({ park_id => $park->id }),
    park_stars => $park_stars,
  );
  my $either = $service->add_star;
  ok $either->is_right;
};

subtest 'error_case' => sub {
  my $service = HirakataPapark::Service::User::AddParkStar::AddParkStar->new(
    db         => $db,
    lang       => 'ja',
    user       => $user,
    params     => HirakataPapark::Validator::Params->new({ park_id => $park->id }),
    park_stars => $park_stars,
  );
  my $either = $service->add_star;
  ok $either->is_left;
  $either->left->map(sub ($exception) {
    like $exception, qr/duplicate key/;
  });
};

done_testing;

