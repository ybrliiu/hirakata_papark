use HirakataPapark 'test';
use Plack::Session;
use Plack::Session::Store::File;
use Plack::Session::State::Cookie;
use Test::HirakataPapark::Container;
use HirakataPapark::Validator::Params;
use HirakataPapark::Service::User::Login::Login;

my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;
my $users = $c->get_sub_container('Model')->get_sub_container('Users')->get_service('users')->get;
my $tc = $c->get_sub_container('TestData');
my $user = $tc->get_sub_container('User')->get_service('user')->get;

subtest 'success_case' => sub {
  my $service = HirakataPapark::Service::User::Login::Login->new(
    lang    => 'ja',
    users   => $users,
    params  => HirakataPapark::Validator::Params->new({
      id       => $user->id,
      password => $user->password,
    }),
    session => Plack::Session->new({
      'psgix.session'         => Plack::Session::State::Cookie->new(session_key => 'hirakata_papark_sid'),
      'psgix.session.options' => Plack::Session::Store::File->new(dir => './etc/sessions'),
    }),
  );
  my $either = $service->login;
  ok $either->is_right;
};

subtest 'error_case' => sub {
  my $service = HirakataPapark::Service::User::Login::Login->new(
    lang    => 'ja',
    users   => $users,
    params  => HirakataPapark::Validator::Params->new({
      id       => $user->id,
      password => '',
    }),
    session => Plack::Session->new({
      'psgix.session'         => Plack::Session::State::Cookie->new(session_key => 'hirakata_papark_sid'),
      'psgix.session.options' => Plack::Session::Store::File->new(dir => './etc/sessions'),
    }),
  );
  my $either = $service->login;
  ok $either->is_left;
  $either->left->map(sub ($e) {
    my $errors = $e->get_error_messages;
    is @$errors, 1;
    is $errors->[0], 'パスワードを入力してください。';
  });
};

done_testing;

