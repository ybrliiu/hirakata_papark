use HirakataPapark 'test';
use Test::HirakataPapark::Container;
use HirakataPapark::Validator::Params;
use HirakataPapark::Service::User::Park::ImagePoster::Poster;

my $c = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;
my $tc = $c->get_sub_container('TestData');
my $user = $tc->get_sub_container('User')->get_service('user')->get;
my $park = $tc->get_sub_container('Park')->get_service('park')->get;
my $park_images = $c->get_sub_container('Model')->get_sub_container('Parks')->get_service('images')->get;
my $image_file = $tc->get_sub_container('Web')->get_service('upload')->get;

subtest 'success_case' => sub {
  my $poster = HirakataPapark::Service::User::Park::ImagePoster::Poster->new(
    db     => $db,
    lang   => 'ja',
    user   => $user,
    params => HirakataPapark::Validator::Params->new({
      park_id    => $park->id,
      title      => '絶景',
      image_file => $image_file,
    }),
    park_images => $park_images,
  );
  my $either = $poster->post;
  ok $either->is_right;
};

done_testing;

