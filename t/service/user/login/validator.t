use Test::HirakataPapark;
use Option;
use Test::HirakataPapark::Container;
use HirakataPapark::Validator::Params;
use HirakataPapark::Service::User::Login::MessageData;
use HirakataPapark::Service::User::Login::Validator;

my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;
my $users = $c->get_sub_container('Model')->get_sub_container('Users')->get_service('users')->get;
my $tc = $c->get_sub_container('TestData');
my $user = $tc->get_sub_container('User')->get_service('user')->get;
my $maybe_user = option $user;
my $message_data =
  HirakataPapark::Service::User::Login::MessageData->instance->message_data('ja');

subtest 'user_not_found' => sub {
  my $id = 'risa_shinomiya';
  my $maybe_user = $users->get_row_by_id($id);
  my $params = HirakataPapark::Validator::Params->new({
    id       => $id,
    password => 'hogerahogera',
  });
  my $validator;
  lives_ok {
    $validator = HirakataPapark::Service::User::Login::Validator->new(
      params       => $params,
      maybe_user   => $maybe_user,
      message_data => $message_data,
    );
  };
  my $either = $validator->validate;
  ok $either->is_left;
  $either->left->map(sub ($e) {
    my $errors = $e->get_error_messages;
    is @$errors, 1;
    is $errors->[0], 'そのIDのユーザーは存在しません。';
  });
};

subtest 'bad password' => sub {
  my $params = HirakataPapark::Validator::Params->new({
    id       => $user->id,
    password => 'prprprpr',
  });
  my $validator;
  lives_ok {
    $validator = HirakataPapark::Service::User::Login::Validator->new(
      params       => $params,
      maybe_user   => $maybe_user,
      message_data => $message_data,
    );
  };
  my $either = $validator->validate;
  ok $either->is_left;
  $either->left->map(sub ($e) {
    my $errors = $e->get_error_messages;
    is @$errors, 1;
    is $errors->[0], 'パスワードが正しくありません。';
  });
};

subtest 'success' => sub {
  my $params = HirakataPapark::Validator::Params->new({
    id       => $user->id,
    password => $user->password,
  });
  my $validator;
  lives_ok {
    $validator = HirakataPapark::Service::User::Login::Validator->new(
      params       => $params,
      maybe_user   => $maybe_user,
      message_data => $message_data,
    );
  };
  my $either = $validator->validate;
  ok $either->is_right;
};

done_testing;

