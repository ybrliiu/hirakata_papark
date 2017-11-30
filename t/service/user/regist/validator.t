use HirakataPapark 'test';
use HirakataPapark::Service::User::Regist::ValidatorMessageDataFactory;
use HirakataPapark::Service::User::Regist::Validator;

my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;
my $users = $c->get_sub_container('Model')->get_sub_container('Users')->get_service('users')->get;
my $message_data =
  HirakataPapark::Service::User::Regist::ValidatorMessageDataFactory->instance->message_data('ja');

{
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
}

{
  my $validator;
  lives_ok {
    $validator = HirakataPapark::Service::User::Regist::Validator->new(
      name         => 'りさ',
      id           => 'risa_shinomiyaああ',
      password     => '@R!as04+_+08',
      users        => $users,
      message_data => $message_data,
    );
  };
  my $e = $validator->validate;
  ok $e->is_left;
  $e->left->foreach(sub ($v) {
    is $v->get_error_messages->[0], q{IDは英数字及び'_', '-'からなる文字列を入力して下さい。};
  });
}

done_testing;

