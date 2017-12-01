use HirakataPapark 'test';
use Test::HirakataPapark::Container;
use HirakataPapark::Service::User::Regist::MessageData;
use HirakataPapark::Service::User::Regist::Validator;

my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;
my $users = $c->get_sub_container('Model')->get_sub_container('Users')->get_service('users')->get;
my $message_data =
  HirakataPapark::Service::User::Regist::MessageData->instance->message_data('ja');

subtest success => sub {
  my $validator;
  lives_ok {
    $validator = HirakataPapark::Service::User::Regist::Validator->new(
      name         => 'りさ',
      id           => 'risa_shinomiyaa',
      password     => '@R!as04+_+08',
      users        => $users,
      message_data => $message_data,
    );
  };
  ok $validator->validate->is_right, 'is right';
};

subtest id_and_password_error => sub {
  my $validator;
  lives_ok {
    $validator = HirakataPapark::Service::User::Regist::Validator->new(
      name         => 'りさ',
      id           => 'risa_shinomiyaああ',
      password     => 'prprprprprprpr',
      users        => $users,
      message_data => $message_data,
    );
  };
  my $e = $validator->validate;
  ok $e->is_left;
  $e->left->foreach(sub ($v) {
    ok $v->get_error_messages, 2;
    is $v->get_error_messages->[0], q{IDは英数字及び'_', '-'からなる文字列を入力して下さい。};
    is $v->get_error_messages->[1], q{パスワードは英字を1文字以上, 数字を1文字以上含むように入力して下さい。};
  });
};

subtest already_exist => sub {
  $users->add_row({
    id       => 'another_id',
    name     => 'りさ',
    password => '!"REWQW"E#F$#S',
  });
  my $validator;
  lives_ok {
    $validator = HirakataPapark::Service::User::Regist::Validator->new(
      id           => 'another_id',
      name         => 'りさ',
      password     => '@R!as04+_+08',
      users        => $users,
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

