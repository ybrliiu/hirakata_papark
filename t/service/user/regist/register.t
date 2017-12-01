use HirakataPapark 'test';
use Test::HirakataPapark::Container;
use HirakataPapark::Validator::Params;
use HirakataPapark::Service::User::Regist::MessageData;
use HirakataPapark::Service::User::Regist::Validator;
use HirakataPapark::Service::User::Regist::Register;

my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;
my $users = $c->get_sub_container('Model')->get_sub_container('Users')->get_service('users')->get;
my $message_data =
  HirakataPapark::Service::User::Regist::MessageData->instance->message_data('ja');

subtest 'success_case' => sub {
  my $validator = HirakataPapark::Service::User::Regist::Validator->new(
    params => HirakataPapark::Validator::Params->new({
      id       => 'risa_shinomiyaa',
      name     => 'りさ',
      password => 'caleer40d#+s',
    }),
    users        => $users,
    message_data => $message_data,
  );
  my $service = HirakataPapark::Service::User::Regist::Register->new(
    db        => $users->db,
    validator => $validator,
  );
  my $result = $service->regist;
  ok $result->is_right;
};

subtest 'error_case' => sub {
  my $validator = HirakataPapark::Service::User::Regist::Validator->new(
    params => HirakataPapark::Validator::Params->new({
      id       => 'hogehoge',
      name     => 'ほげらー',
      password => 'vvvvvvvvvvvv',
    }),
    users        => $users,
    message_data => $message_data,
  );
  my $service = HirakataPapark::Service::User::Regist::Register->new(
    db        => $users->db,
    validator => $validator,
  );
  my $result = $service->regist;
  ok $result->is_left;
  $result->left->map(sub ($e) {
    is $e->get_error_messages->@*, 1;
    is $e->get_error_messages->[0], 'パスワードは英字を1文字以上, 数字を1文字以上含むように入力して下さい。';
  });
};

done_testing;

