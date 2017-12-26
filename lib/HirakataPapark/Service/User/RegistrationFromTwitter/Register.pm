package HirakataPapark::Service::User::RegistrationFromTwitter::Register {

  use Mouse;
  use HirakataPapark;
  use Either;
  use Try::Tiny;
  use HirakataPapark::Validator::Params;
  use HirakataPapark::Service::User::RegistrationFromTwitter::Validator;
  use HirakataPapark::Service::User::RegistrationFromTwitter::MessageData;

  use constant ERRORS_SESSION_KEY => 'sns_register.errors';

  has 'lang' => ( is => 'ro', isa => 'HirakataPapark::lang', required => 1 );

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

  has 'params' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Validator::Params',
    lazy    => 1,
    builder => '_build_params',
  );

  has 'validator' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Service::User::RegistrationFromTwitter::Validator',
    lazy    => 1,
    builder => '_build_validator',
  );

  with qw(
    HirakataPapark::Service::Role::DB
    HirakataPapark::Service::User::Role::UseTwitterAPI
  );

  sub _build_message_data($self) {
    HirakataPapark::Service::User::RegistrationFromTwitter::MessageData
      ->instance->message_data($self->lang);
  }

  sub _build_params($self) {
    my $res = $self->api_caller->account_verify_credentials;
    my $params = {
      id         => $res->{screen_name},
      name       => $res->{name},
      password   => 'twitter',
      address    => $res->{location},
      twitter_id => $res->{id},
    };
    HirakataPapark::Validator::Params->new($params);
  }

  sub _build_validator($self) {
    HirakataPapark::Service::User::RegistrationFromTwitter::Validator->new({
      users        => $self->users,
      params       => $self->params,
      message_data => $self->message_data,
    });
  }

  # -> Either[ Int | Validator | Exception ]
  sub regist($self) {
    $self->validator->validate->match(
      Right => sub {
        my $txn_scope = $self->txn_scope;
        my $result = try {
          $self->users->add_row( $self->params->to_hash );
          right 1;
        } catch {
          $txn_scope->rollback;
          left $_;
        };
        $result->map(sub { $txn_scope->commit });
      },
      Left => sub ($v) {
        $self->session->set(ERRORS_SESSION_KEY ,=> $v);
        left $v;
      },
    );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

