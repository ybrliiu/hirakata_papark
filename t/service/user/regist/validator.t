use HirakataPapark 'test';
use HirakataPapark::Service::User::Regist::Validator;

{
  my $validator;
  lives_ok {
    $validator = HirakataPapark::Service::User::Regist::Validator->new(
      name     => 'りさ',
      id       => 'risa_shinomiyaa',
      password => '@R!as04+_+08',
    );
  };
  ok $validator->validate->is_right, 'is right';
}

{
  my $validator;
  lives_ok {
    $validator = HirakataPapark::Service::User::Regist::Validator->new(
      name     => 'りさ',
      id       => 'risa_shinomiyaああ',
      password => '@R!as04+_+08',
    );
  };
  my $e = $validator->validate;
  ok $e->is_left;
  $e->left->foreach(sub ($v) {
    is $v->get_error_messages->[0], q{IDは英数字及び'_', '-'からなる文字列を入力して下さい。};
  });
}

done_testing;

