package HirakataPapark::Service::User::TwitterAuth::PrepareRequestToken {

  use Mouse;
  use HirakataPapark;
  
  with 'HirakataPapark::Service::User::TwitterAuth::TwitterAuth';
  
  has 'callback_url' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );
  
  has 'redirect_url_of_twitter_app_session' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    builder => 'prepare_request_token',
  );
  
  sub prepare_request_token($self) {
    my $request_token = $self->twitter_api->oauth_request_token(callback => $self->callback_url);
    $self->session->set('user.twitter.oauth_token_secret' => $request_token->{oauth_token_secret});
    $self->twitter_api->oauth_authentication_url(oauth_token => $request_token->{oauth_token})->as_string;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

