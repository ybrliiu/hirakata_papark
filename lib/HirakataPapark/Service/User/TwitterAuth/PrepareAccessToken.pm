package HirakataPapark::Service::User::TwitterAuth::PrepareAccessToken {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Service::User::TwitterAuth::TwitterAuth';

  has 'oauth_token'    => ( is => 'ro', isa => 'Str', required => 1 );
  has 'oauth_verifier' => ( is => 'ro', isa => 'Str', required => 1 );
  
  sub prepare_access_token($self) {
    my $res = $self->twitter_api->oauth_access_token(
      token    => $self->oauth_token,
      verifier => $self->oauth_verifier,
    );
    my $session = $self->session;
    $session->set('user.twitter.oauth_token'        => $res->{oauth_token});
    $session->set('user.twitter.oauth_token_secret' => $res->{oauth_token_secret});
  }

  __PACKAGE__->meta->make_immutable;

}

1;

