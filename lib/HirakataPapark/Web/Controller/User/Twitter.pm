package HirakataPapark::Web::Controller::User::Twitter {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;

  use HirakataPapark::Service::User::LoginFromTwitter;
  use HirakataPapark::Service::User::RegistFromTwitter;
  use HirakataPapark::Service::User::TwitterAuth::PrepareRequestToken;
  use HirakataPapark::Service::User::TwitterAuth::PrepareAccessToken;
  
  has 'login_service' => sub ($self) {
    HirakataPapark::Service::User::LoginFromTwitter->new({
      users   => $self->users,
      session => $self->plack_session,
    });
  };
  
  sub prepare_access_token($self) {
    my $service = HirakataPapark::Service::User::TwitterAuth::PrepareAccessToken->new({
      session        => $self->plack_session,
      oauth_token    => $self->param('oauth_token'),
      oauth_verifier => $self->param('oauth_verifier'),
    });
    $service->prepare_access_token;
  }
  
  sub register($self) {
    my $service = HirakataPapark::Service::User::TwitterAuth::PrepareRequestToken->new({
      session      => $self->plack_session,
      callback_url => $self->url_for("/@{[ $self->lang ]}/user/twitter/callback-register")->to_abs->to_string,
    });
    $self->redirect_to($service->redirect_url_of_twitter_app_session);
  }

  sub callback_register($self) {
    $self->prepare_access_token;
    $self->redirect_to("/@{[ $self->lang ]}/user/twitter/regist");
  }

  sub regist($self) {
    my $service = HirakataPapark::Service::User::RegistFromTwitter->new({
      db      => $self->users->db,
      users   => $self->users,
      session => $self->plack_session,
    });
    $service->regist->match(
      # あとで登録前見ていたページに飛ばせるようにしたい
      Right => sub {
        $self->login_service->login->match(
          Right => sub {
            $self->redirect_to("/@{[ $self->lang ]}/user/mypage");
          },
          Left => sub { die $_ },
        );
      },
      Left  => sub ($e) { die $e },
    );
  }

  # sessionというメソッド名は使えないので(Mojoliciousのhelperに含まれるため)
  sub action_session($self) {
    my $service = HirakataPapark::Service::User::TwitterAuth::PrepareRequestToken->new({
      session      => $self->plack_session,
      callback_url => $self->url_for("/@{[ $self->lang ]}/user/twitter/callback-session")->to_abs->to_string,
    });
    $self->redirect_to($service->redirect_url_of_twitter_app_session);
  }

  sub callback_session($self) {
    $self->prepare_access_token;
    $self->redirect_to("/@{[ $self->lang ]}/user/twitter/login");
  }

  sub login($self) {
    $self->login_service->login->match(
      # あとでログイン前見ていたページに飛ばせるようにしたい
      Right => sub { $self->redirect_to("/@{[ $self->lang ]}/user/mypage") },
      # エラー内容によって処理分岐(twitterからの登録を促したり)
      Left  => sub ($e) { die $e },
    );
  }

}

1;

