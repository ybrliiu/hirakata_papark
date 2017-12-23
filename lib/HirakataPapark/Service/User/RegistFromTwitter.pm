package HirakataPapark::Service::User::RegistFromTwitter {

  use Mouse;
  use HirakataPapark;
  use Either;
  use Try::Tiny;

  has 'users' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Users::Users',
    required => 1,
  );

  with qw(
    HirakataPapark::Service::Role::DB
    HirakataPapark::Service::User::TwitterAuth::TwitterAuth
  );

  # -> Either
  sub regist($self) {
    my $session = $self->session;
    my $res = $self->twitter_api->get('account/verify_credentials', {
      -token        => $session->get('user.twitter.oauth_token'),
      -token_secret => $session->get('user.twitter.oauth_token_secret'),
    });
    my $params = {
      id              => $res->{id},
      name            => $res->{name},
      password        => 'twitter',
      address         => $res->{location},
      is_from_twitter => 1,
    };
    my $txn_scope = $self->txn_scope;
    my $result = try {
      $self->users->add_row($params);
      right 1;
    } catch {
      # twitter id と name の重複がある場合
      # 既に登録している場合 -> twitter_idを検索, あればログイン画面に飛ばす
      # なければ修正登録画面に飛ばす
      $txn_scope->rollback;
      left $_;
    };
    $result->map(sub { $txn_scope->commit });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

