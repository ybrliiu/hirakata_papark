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

  sub login($self) {
    my $session = $self->session;
    my $res = $self->twitter_api->get('account/verify_credentials', {
      -token        => $session->get('user.twitter.oauth_token'),
      -token_secret => $session->get('user.twitter.oauth_token_secret'),
    });
    my $user_id = $res->{id};
    $self->users->get_row_by_id($user_id)->match(
      Some => sub ($user) {
        if ($user->is_from_twitter) {
          $self->session->set(change_id => 1);
          $self->session->set('user.id' => $user->id);
          right 1;
        }
        # このサイトから直接ユーザー登録するときに, 
        # IDにtwitterAPIで取得できるtwitterのid(screen_nameではない)
        # をidとしてこのサイトに登録し, のちにtwitterからログインしようとした場合
        else {
          left 'Invalid login method';
        }
      },
      None => sub { left 'No such user' },
    );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

