use HirakataPapark 'test';
use Test::HirakataPapark::Container;
use HirakataPapark::Service::User::Park::Tagger::Tagger;

my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;
my $tc = $c->get_sub_container('TestData');
my $park = $tc->get_sub_container('Park')->get_service('park')->get;
my $park_tags = $c->get_sub_container('Model')->get_sub_container('Parks')->get_service('tags')->get;
my $params = {
  db         => $db,
  lang       => 'ja',
  params     => HirakataPapark::Validator::Params->new({
    park_id  => $park->id,
    tag_name => '広ろーい',
  }),
  park_tags => $park_tags,
};

subtest 'add success_case' => sub {
  my $service = HirakataPapark::Service::User::Park::Tagger::Tagger->new($params);
  my $either = $service->add_tag;
  ok $either->is_right;
};

subtest 'add error_case' => sub {
  my $service = HirakataPapark::Service::User::Park::Tagger::Tagger->new($params);
  my $either = $service->add_tag;
  ok $either->is_left;
  $either->left->map(sub ($exception) {
    my $error_messages = $exception->get_error_messages;
    is @$error_messages, 1;
    is $error_messages->[0], 'そのタグ名は既に使用されています。';
  });
};

done_testing;

