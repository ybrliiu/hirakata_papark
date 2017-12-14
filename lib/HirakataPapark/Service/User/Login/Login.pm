package HirakataPapark::Service::User::Login::Login {

  use Mouse;
  use HirakataPapark;
  use Either;

  use HirakataPapark::Service::User::Login::Validator;
  use HirakataPapark::Service::User::Login::MessageData;

  has 'lang' => ( is => 'ro', isa => 'HirakataPapark::lang', required => 1 );
  
  has 'params' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Validator::Params',
    required => 1,
  );

  has 'session' => (
    is       => 'ro',
    isa      => 'Plack::Session',
    required => 1,
  );

  has 'users' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Users::Users',
    required => 1,
  );

  has 'message_data' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Validator::MessageData',
    lazy    => 1,
    builder => '_build_message_data',
  );

  has 'validator' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Service::User::Login::Validator',
    lazy    => 1,
    builder => '_build_validator',
  );
  
  has 'maybe_user' => (
    is      => 'ro',
    isa     => 'Option::Option',
    lazy    => 1,
    builder => '_build_maybe_user',
  );

  sub _build_message_data($self) {
    HirakataPapark::Service::User::Login::MessageData
      ->instance->message_data($self->lang);
  }

  sub _build_validator($self) {
    HirakataPapark::Service::User::Login::Validator->new({
      params       => $self->params,
      maybe_user   => $self->maybe_user,
      message_data => $self->message_data,
    });
  }
  
  sub _build_maybe_user($self) {
    $self->users->get_row_by_id( $self->params->param('id')->get_or_else('') );
  }

  sub login($self) {
    $self->validator->validate->map(sub ($user) {
      $self->session->set(change_id => 1);
      $self->session->set('user.id' => $user->id);
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

