package HirakataPapark::Web::Controller::User {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;

  use HirakataPapark::Validator::Params;
  use HirakataPapark::Service::User::Login::Login;
  use HirakataPapark::Service::User::Regist::Register;

  sub login($self) {
    my $service = HirakataPapark::Service::User::Login::Login->new({
      lang    => $self->lang,
      users   => $self->users,
      params  => HirakataPapark::Validator::Params->new({
        map { $_ => $self->param($_) } qw( id password )
      }),
      session => $self->plack_session,
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
          users    => $self->users,
          params   => HirakataPapark::Validator::Params->new({
            map { $p->param($_)->get } qw( id password )
          }),
          session  => $self->plack_session,
        })->login;
        +{ is_success => 1 };
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

}

1;

