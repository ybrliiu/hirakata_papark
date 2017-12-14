package HirakataPapark::Web::Controller::User {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;

  use Option;
  use HirakataPapark::Exception;
  use HirakataPapark::Validator::Params;
  use HirakataPapark::Model::Users::Users;
  use HirakataPapark::Service::User::Login::Login;
  use HirakataPapark::Service::User::Regist::Register;
  use HirakataPapark::Service::User::LoginFromTwitter;
  use HirakataPapark::Service::User::RegistFromTwitter;
  use HirakataPapark::Service::User::TwitterAuth::PrepareRequestToken;
  use HirakataPapark::Service::User::TwitterAuth::PrepareAccessToken;
  
  has 'login_from_twitter_service' => sub ($self) {
    HirakataPapark::Service::User::LoginFromTwitter->new({
      users   => $self->users,
      session => $self->plack_session,
    });
  };
  
  sub prepare_twitter_access_token($self) {
    my $service = HirakataPapark::Service::User::TwitterAuth::PrepareAccessToken->new({
      session        => $self->plack_session,
      oauth_token    => $self->param('oauth_token'),
      oauth_verifier => $self->param('oauth_verifier'),
    });
    $service->prepare_access_token;
  }

  sub login($self) {
    my $service = HirakataPapark::Service::User::Login::Login->new({
      lang     => $self->lang,
      id       => $self->param('id') // '',
      password => $self->param('password') // '',
      session  => $self->plack_session,
      users    => $self->users,
    });
    my $json = $service->login->match(
      Right => sub { { is_success => 1 } },
      Left  => sub ($e) { { is_success => 0, errors => $e->errors_and_messages } },
    );
    $self->render(json => $json);
  }

  sub logout($self) {
    $self->plack_session->expire;
    $self->redirect_to('/' . $self->lang);
  }

  sub register($self) {
    $self->stash({
      validator    => 'HirakataPapark::Service::User::Regist::Validator',
      message_data => HirakataPapark::Service::User::Regist::MessageData->instance->message_data($self->lang),
    });
    $self->render_to_multiple_lang;
  }

  sub regist($self) {
    my $service = HirakataPapark::Service::User::Regist::Register->new({
      db     => $self->users->db,
      users  => $self->users,
      lang   => $self->lang,
      params => HirakataPapark::Validator::Params->new({
        map {
          my $param = $self->param($_);
          defined $param ? ($_ => $param) : ();
        } qw( id name password address profile )
      }),
    });
    my $json = $service->regist->match(
      Right => sub ($p) {
        HirakataPapark::Service::User::Login::Login->new({
          lang     => $self->lang,
          id       => $p->param('id')->get,
          password => $p->param('password')->get,
          session  => $self->plack_session,
          users    => $self->users,
        })->login;
        { is_success => 1, params => $p->to_hash };
      },
      Left => sub ($e) {
        if ( $e->isa('HirakataPapark::Validator') ) {
          { is_success => 0, errors => $e->errors_and_messages };
        } else {
          die $e;
        }
      },
    );
    $self->render(json => $json);
  }

  sub action_session($self) {
    $self->render_to_multiple_lang(template => 'user/session');
  }
  
  sub register_from_twitter($self) {
    my $service = HirakataPapark::Service::User::TwitterAuth::PrepareRequestToken->new({
      session      => $self->plack_session,
      callback_url => $self->url_for("/@{[ $self->lang ]}/user/callback-register-from-twitter")->to_abs->to_string,
    });
    $self->redirect_to($service->redirect_url_of_twitter_app_session);
  }

  sub callback_register_from_twitter($self) {
    $self->prepare_twitter_access_token;
    $self->redirect_to("/@{[ $self->lang ]}/user/regist-from-twitter");
  }

  sub regist_from_twitter($self) {
    my $service = HirakataPapark::Service::User::RegistFromTwitter->new({
      db      => $self->users->db,
      users   => $self->users,
      session => $self->plack_session,
    });
    $service->regist->match(
      # あとで登録前見ていたページに飛ばせるようにしたい
      Right => sub {
        $self->login_from_twitter_service->login->match(
          Right => sub {
            $self->redirect_to("/@{[ $self->lang ]}/user/mypage");
          },
          Left => sub { die $_ },
        );
      },
      Left  => sub ($e) { die $e },
    );
  }

  sub session_from_twitter($self) {
    my $service = HirakataPapark::Service::User::TwitterAuth::PrepareRequestToken->new({
      session      => $self->plack_session,
      callback_url => $self->url_for("/@{[ $self->lang ]}/user/callback-session-from-twitter")->to_abs->to_string,
    });
    $self->redirect_to($service->redirect_url_of_twitter_app_session);
  }

  sub callback_session_from_twitter($self) {
    $self->prepare_twitter_access_token;
    $self->redirect_to("/@{[ $self->lang ]}/user/login-from-twitter");
  }

  sub login_from_twitter($self) {
    $self->login_from_twitter_service->login->match(
      # あとでログイン前見ていたページに飛ばせるようにしたい
      Right => sub { $self->redirect_to("/@{[ $self->lang ]}/user/mypage") },
      # エラー内容によって処理分岐(twitterからの登録を促したり)
      Left  => sub ($e) { die $e },
    );
  }

}

1;

