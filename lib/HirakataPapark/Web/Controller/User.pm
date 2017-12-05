package HirakataPapark::Web::Controller::User {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;

  use Option;
  use HirakataPapark::Exception;
  use HirakataPapark::Validator::Params;
  use HirakataPapark::Model::Users::Users;
  use HirakataPapark::Service::User::Login::Login;
  use HirakataPapark::Service::User::Regist::Validator;
  use HirakataPapark::Service::User::Regist::MessageData;
  use HirakataPapark::Service::User::Regist::Register;

  has 'users' => sub { HirakataPapark::Model::Users::Users->new };

  has 'regist_message_data' => sub ($self) {
    HirakataPapark::Service::User::Regist::MessageData
      ->instance->message_data($self->lang);
  };

  sub auth($self) {
    if ( $self->plack_session->get('user.id') ) {
      1;
    } else {
      $self->render(status => 403, text => 'Unauthorized');
      0;
    }
  }

  sub login($self) {
    my $service = HirakataPapark::Service::User::Auth::Auth->new({
      lang     => $self->lang,
      id       => $self->param('id'),
      password => $self->param('password'),
      session  => $self->plack_session,
      users    => $self->users,
    });
    my $json = $service->login->match(
      Right => sub { +{ is_success => 1 } },
      Left  => sub ($e) { +{ is_success => 0, errors => $e->errors_and_messages } },
    );
    $self->render(json => $json);
  }

  sub logout($self) {
    $self->plack_session->expire;
    $self->redirect('/' . $self->lang);
  }

  sub register($self) {
    $self->stash({
      validator    => 'HirakataPapark::Service::User::Regist::Validator',
      message_data => $self->regist_message_data,
    });
    $self->render_to_multiple_lang;
  }

  sub regist($self) {
    my $validator = HirakataPapark::Service::User::Regist::Validator->new({
      params => HirakataPapark::Validator::Params->new({
        map {
          my $param = $self->param($_);
          defined $param ? ($_ => $param) : ();
        } qw( id name password address profile )
      }),
      users        => $self->users,
      message_data => $self->regist_message_data,
    });
    my $service = HirakataPapark::Service::User::Regist::Register->new({
      db        => $self->users->db,
      validator => $validator,
    });
    my $result = $service->regist;
    my $json = $result->match(
      Right => sub ($p) {
        HirakataPapark::Service::User::Login::Login->new({
          lang     => $self->lang,
          id       => $p->param('id'),
          password => $p->param('password'),
          session  => $self->plack_session,
          users    => $self->users,
        })->login;
        +{ is_success => 1, params => $p->to_hash };
      },
      Left => sub ($e) {
        if ( $e->isa('HirakataPapark::Validator') ) {
          +{ is_success => 0, errors => $e->errors_and_messages };
        } else {
          HirakataPapark::Exception->throw($e);
        }
      },
    );
    $self->render(json => $json);
  }

}

1;

