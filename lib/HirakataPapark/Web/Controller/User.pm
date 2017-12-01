package HirakataPapark::Web::Controller::User {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;

  use HirakataPapark::Validator::Params;
  use HirakataPapark::Model::Users::Users;
  use HirakataPapark::Service::User::Regist::Validator;
  use HirakataPapark::Service::User::Regist::MessageData;
  use HirakataPapark::Service::User::Regist::Register;

  has 'users' =>
    sub { HirakataPapark::Model::Users::Users->new };

  has 'message_data' =>
    sub ($self) {
      HirakataPapark::Service::User::Regist::MessageData
        ->instance->message_data($self->lang);
    };

  sub register($self) {
    $self->stash({
      validator    => 'HirakataPapark::Service::User::Regist::Validater',
      message_data => $self->message_data,
    });
    $self->render_to_multiple_lang;
  }

  sub regist($self) {
    my $validator = HirakataPapark::Service::User::Regist::Validater->new({
      params => HirakataPapark::Validator::Params->new({
        map { $_ => $self->param($_) } qw( id name password address profile )
      }),
      users        => $self->users,
      message_data => $self->message_data,
    });
    my $service = HirakataPapark::Service::User::Regist::Register->new({
      db        => $self->users->db,
      validator => $validator,
    });
    my $result = $service->regist;
    my $json = $result->match(
      Right => sub ($p) {+{
        is_success => 1,
        params     => $p->to_hash,
      }},
      Left => sub ($e) {+{
        is_success => 0,
        errors     => $e->errors_and_messages,
      }},
    );
    $self->render(json => $json);
  }

}

1;

