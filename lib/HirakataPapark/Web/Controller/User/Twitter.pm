package HirakataPapark::Web::Controller::User::Twitter {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;

  use Option;
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

  sub prepare_request_token($self, $callback_url) {
    option( $self->param('originally_seen_page') )->match(
      Some => sub ($originally_seen_page) {
        my $service = HirakataPapark::Service::User::TwitterAuth::PrepareRequestToken->new({
          session              => $self->plack_session,
          callback_url         => $self->url_for($callback_url)->to_abs->to_string,
          originally_seen_page => $originally_seen_page,
        });
        $self->redirect_to($service->redirect_url_of_twitter_app_session);
      },
      None => sub { $self->render_not_found },
    );
  }
  
  sub prepare_access_token($self, $redirect_url) {
    my $service = HirakataPapark::Service::User::TwitterAuth::PrepareAccessToken->new({
      session        => $self->plack_session,
      oauth_token    => $self->param('oauth_token'),
      oauth_verifier => $self->param('oauth_verifier'),
    });
    $service->prepare_access_token;
    $self->redirect_to($redirect_url);
  }
  
  sub register($self) {
    $self->prepare_request_token("/@{[ $self->lang ]}/user/twitter/callback-register");
  }

  sub callback_register($self) {
    $self->prepare_access_token("/@{[ $self->lang ]}/user/twitter/regist");
  }

  sub regist($self) {
    my $service = HirakataPapark::Service::User::RegistFromTwitter->new({
      db      => $self->users->db,
      users   => $self->users,
      session => $self->plack_session,
    });
    $service->regist->match(
      Right => sub {
        $self->login_service->login->match(
          Right => sub {
            my $redirect_page = option( $self->plack_session->get('user.originally_seen_page') )
            ->get_or_else("/@{[ $self->lang ]}/user/mypage");
            $self->redirect_to($redirect_page);
          },
          Left => sub { die $_ },
        );
      },
      # 同じユーザー名, ID名だったときはどうする
      Left  => sub ($e) { die $e },
    );
  }

  # sessionというメソッド名は使えないので(Mojoliciousのhelperに含まれるため)
  sub action_session($self) {
    $self->prepare_request_token("/@{[ $self->lang ]}/user/twitter/callback-session");
  }

  sub callback_session($self) {
    $self->prepare_access_token("/@{[ $self->lang ]}/user/twitter/login");
  }

  sub login($self) {
    $self->login_service->login->match(
      Right => sub {
        my $redirect_page = option( $self->plack_session->get('user.originally_seen_page') )
          ->get_or_else("/@{[ $self->lang ]}/user/mypage");
        $self->redirect_to($redirect_page);
      },
      # エラー内容によって処理分岐(twitterからの登録を促したり)
      Left => sub ($e) { die $e },
    );
  }

}

1;

