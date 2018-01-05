use Test::HirakataPapark;
use Test::HirakataPapark::Container;
use HirakataPapark::Validator::Params;
use HirakataPapark::Service::User::Regist::MessageData;
use HirakataPapark::Service::User::Regist::Validator;

my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;
my $users = $c->get_sub_container('Model')->get_sub_container('Users')->get_service('users')->get;
my $message_data =
  HirakataPapark::Service::User::Regist::MessageData->instance->message_data('ja');

subtest success => sub {
  my $params = HirakataPapark::Validator::Params->new({
    name     => 'りさ',
    id       => 'risa_shinomiyaa',
    password => '@R!as04+_+08',
  });
  my $validator;
  lives_ok {
    $validator = HirakataPapark::Service::User::Regist::Validator->new(
      params       => $params,
      users        => $users,
      message_data => $message_data,
    );
  };
  ok $validator->validate->is_right, 'is right';
};

subtest id_and_password_error => sub {
  my $params = HirakataPapark::Validator::Params->new({
    name     => 'りさ',
    id       => 'risa_shinomiyaああ',
    password => 'prprprprprprpr',
  });
  my $validator;
  lives_ok {
    $validator = HirakataPapark::Service::User::Regist::Validator->new(
      params       => $params,
      users        => $users,
      message_data => $message_data,
    );
  };
  my $e = $validator->validate;
  ok $e->is_left;
  $e->left->foreach(sub ($v) {
    ok $v->get_error_messages, 2;
    is $v->get_error_messages->[0], q{使用できる文字は半角英数字及び'_', '-'です。};
    is $v->get_error_messages->[1], q{使用できる文字は半角英数字、記号で、数字を必ず1文字以上含めて下さい。};
  });
};

subtest already_exist => sub {
  my $params = HirakataPapark::Validator::Params->new({
    id       => 'another_id',
    name     => 'りさ',
    password => '!"REWQW"E#F$2#S',
  });
  $users->add_row($params->to_hash);
  my $validator;
  lives_ok {
    $validator = HirakataPapark::Service::User::Regist::Validator->new(
      users        => $users,
      params       => $params,
      message_data => $message_data,
    );
  };
  my $e = $validator->validate;
  ok $e->is_left;
  $e->left->foreach(sub ($v) {
    is $v->get_error_messages->@*, 2;
    is $v->get_error_messages->[0], q{そのIDは既に使用されています。};
    is $v->get_error_messages->[1], q{その名前は既に使用されています。};
  });
};

done_testing;

