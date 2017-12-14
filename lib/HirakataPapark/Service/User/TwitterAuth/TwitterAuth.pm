package HirakataPapark::Service::User::TwitterAuth::TwitterAuth {

  use Mouse::Role;
  use HirakataPapark;
  use Twitter::API;
  use HirakataPapark::Model::Config;
  
  has 'session' => (
    is       => 'ro',
    isa      => 'Plack::Session',
    required => 1,
  );

  has 'twitter_api' => (
    is      => 'ro',
    isa     => 'Twitter::API',
    lazy    => 1,
    builder => '_build_twitter_api',
  );
  
  sub _build_twitter_api($self) {
    my $config = HirakataPapark::Model::Config->instance->get_config('twitter')->get;
    Twitter::API->new(
      consumer_key    => $config->{consumer_key},
      consumer_secret => $config->{consumer_secret},
    );
  }

}

1;

