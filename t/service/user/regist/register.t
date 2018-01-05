use Test::HirakataPapark;
use Test::HirakataPapark::Container;
use HirakataPapark::Validator::Params;
use HirakataPapark::Service::User::Regist::MessageData;
use HirakataPapark::Service::User::Regist::Validator;
use HirakataPapark::Service::User::Regist::Register;

my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;
my $users = $c->get_sub_container('Model')->get_sub_container('Users')->get_service('users')->get;

subtest 'success_case' => sub {
  my $service = HirakataPapark::Service::User::Regist::Register->new(
    db     => $users->db,
    lang   => 'ja',
    users  => $users,
    params => HirakataPapark::Validator::Params->new({
      id       => 'risa_shinomiyaa',
      name     => 'りさ',
      password => 'caleer40d#+s',
    }),
  );
  my $result = $service->regist;
  ok $result->is_right;
};

subtest 'error_case' => sub {
  my $service = HirakataPapark::Service::User::Regist::Register->new(
    db     => $users->db,
    lang   => 'ja',
    users  => $users,
    params => HirakataPapark::Validator::Params->new({
      id       => 'hogehoge',
      name     => 'ほげらー',
      password => 'vvvvvvvvvvvv',
    }),
  );
  my $result = $service->regist;
  ok $result->is_left;
  $result->left->map(sub ($e) {
    my $errors = $e->get_error_messages;
    is @$errors, 1;
    is $errors->[0], '使用できる文字は半角英数字、記号で、数字を必ず1文字以上含めて下さい。';
  });
};

done_testing;

