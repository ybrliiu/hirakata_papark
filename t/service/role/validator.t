use Test::HirakataPapark;
use HirakataPapark::Validator::Params;
use HirakataPapark::Validator::DefaultMessageData;

package TestValidator {

  use Mouse;
  use HirakataPapark;
  use Either;
  with 'HirakataPapark::Service::Role::Validator';

  sub validate($self) {
    my $v = $self->validator;
    $v->check(
      id   => [ 'NOT_NULL', [LENGTH => (3, 6)] ],
      name => [ 'NOT_NULL', [LENGTH => (5, 20)] ],
    );
    $v->has_error ? left($v) : right(1);
  }

  __PACKAGE__->meta->make_immutable;

}

my $lang_data = HirakataPapark::Validator::DefaultMessageData->instance->message_data('ja');

subtest error_case => sub {
  my $params = HirakataPapark::Validator::Params->new({id => 'hogerahogera'});
  my ($v, $e);
  lives_ok {
    $v = TestValidator->new(
      params       => $params,
      message_data => $lang_data,
    );
  };
  lives_ok { $e = $v->validate };
  ok $e->left->map(sub ($e) {
    is $e->get_error_messages->@*, 2;
    is $e->get_error_messages->[0], 'IDが長すぎるか短すぎます。';
    is $e->get_error_messages->[1], '名前を入力してください。';
  });
};

subtest success_case => sub {
  my $params = HirakataPapark::Validator::Params->new({
    id   => 'Karin',
    name => 'かりん',
  });
  my ($v, $e);
  lives_ok {
    $v = TestValidator->new(
      params       => $params,
      message_data => $lang_data,
    );
  };
  lives_ok { $e = $v->validate };
  ok $e->map(sub { 1 });
};

done_testing;

