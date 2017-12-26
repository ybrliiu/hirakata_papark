package HirakataPapark::Web::Controller::User::Twitter {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;

  use Option;
  use HirakataPapark::Service::User::LoginFromTwitter;
  use HirakataPapark::Service::User::RegistrationFromTwitter::Register;
  use HirakataPapark::Service::User::RegistrationFromTwitterModifiable;
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
    my $service = HirakataPapark::Service::User::RegistrationFromTwitter::Register->new({
      db      => $self->users->db,
      lang    => $self->lang,
      users   => $self->users,
      session => $self->plack_session,
    });
    $service->regist->match(
      Right => sub {
        $self->login_service->login->fold(
          sub { die $_ },
          sub ($maybe_originally_seen_page) {
            my $redirect_page = 
              $maybe_originally_seen_page->get_or_else("/@{[ $self->lang ]}/user/mypage");
            $self->redirect_to($redirect_page);
          },
        );
      },
      Left  => sub ($e) {
        if ( $e->isa('HirakataPapark::Validator') ) {
          my $redirect_to = $e->is_error('twitter_id') ? 'login' : 'register-modifiable';
          $self->redirect_to("/@{[ $self->lang ]}/user/twitter/${redirect_to}");
        } else {
          die $e;
        }
      },
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
      Right => sub ($maybe_redirect_page) {
        my $redirect_page = $maybe_redirect_page->get_or_else("/@{[ $self->lang ]}/user/mypage");
        $self->redirect_to($redirect_page);
      },
      Left => sub { $self->redirect_to("/@{[ $self->lang ]}/user/register") },
    );
  }

  sub register_modifiable($self) {
    my $message_data = HirakataPapark::Service::User::Regist::MessageData
      ->instance->message_data($self->lang);
    my $key = HirakataPapark::Service::User::RegistrationFromTwitter::Register->ERRORS_SESSION_KEY;
    my $maybe_register_errors = option $self->plack_session->get($key);
    $self->stash({
      message_data          => $message_data,
      validator             => 'HirakataPapark::Service::User::Regist::Validator',
      maybe_register_errors => $maybe_register_errors,
    });
    $self->plack_session->remove($key);
    $self->render_to_multiple_lang;
  }

  sub regist_modifiable($self) {
    my $service = HirakataPapark::Service::User::RegistrationFromTwitterModifiable->new({
      db      => $self->users->db,
      lang    => $self->lang,
      users   => $self->users,
      params  => HirakataPapark::Validator::Params->new({
        map { $_ => $self->param($_) } qw( id name )
      }),
      session => $self->plack_session,
    });
    my $json = $service->regist->match(
      Right => sub {
        +{
          is_success  => 1,
          redirect_to => $self->url_for($self->lang . '/user/twitter/login')->to_abs->to_string,
        };
      },
      Left => sub ($e) {
        $e->isa('HirakataPapark::Validator')
          ? +{ is_success => 0, errors => $e->errors_and_messages }
          : die $e;
      },
    );
    $self->render(json => $json);
  }

}

1;

