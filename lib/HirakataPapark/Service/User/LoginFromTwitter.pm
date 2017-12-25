package HirakataPapark::Service::User::LoginFromTwitter {

  use Mouse;
  use HirakataPapark;
  use Either;

  has 'users' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Users::Users',
    required => 1,
  );

  with 'HirakataPapark::Service::User::TwitterAuth::TwitterAuth';

  # Either[Int|Str]
  sub login($self) {
    my $session = $self->session;
    my $res = $self->twitter_api->get('account/verify_credentials', {
      -token        => $session->get('user.twitter.oauth_token'),
      -token_secret => $session->get('user.twitter.oauth_token_secret'),
    });
    my $twitter_id = $res->{id};
    $self->users->get_row_by_twitter_id($twitter_id)->match(
      Some => sub ($user) {
        $self->session->set(change_id => 1);
        $self->session->set('user.seacret_id' => $user->seacret_id);
        right 1;
      },
      None => sub { left 'No such user' },
    );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

