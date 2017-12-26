package HirakataPapark::Service::User::TwitterAuth::APICaller {

  use Mouse;
  use HirakataPapark;
  use Option;

  with 'HirakataPapark::Service::User::TwitterAuth::TwitterAuth';

  sub account_verify_credentials($self) {
    my $session = $self->session;
    $self->twitter_api->get('account/verify_credentials', {
      -token        => option( $session->get('user.twitter.oauth_token') )->get,
      -token_secret => option( $session->get('user.twitter.oauth_token_secret') )->get,
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

