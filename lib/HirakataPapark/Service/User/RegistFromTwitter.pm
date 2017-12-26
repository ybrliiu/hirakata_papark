package HirakataPapark::Service::User::RegistFromTwitter {

  use Mouse;
  use HirakataPapark;
  use Option;
  use Either;
  use Try::Tiny;
  use HirakataPapark::Validator;
  use HirakataPapark::Validator::DefaultMessageData;

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

  has 'validator' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Validator',
    lazy    => 1,
    builder => '_build_validator',
  );

  with qw(
    HirakataPapark::Service::Role::DB
    HirakataPapark::Service::User::Role::UseTwitterAPI
  );

  sub _build_message_data($self) {
    HirakataPapark::Validator::DefaultMessageData->instance->message_data($self->lang)
  }

  sub _build_validator($self) {
    my $v = HirakataPapark::Validator->new({});
    $v->set_message_data($self->message_data);
    $v;
  }

  # -> Either[ Int | Validator | Exception ]
  sub regist($self) {
    my $res = $self->api_caller->account_verify_credentials;
    my $params = {
      id         => $res->{screen_name},
      name       => $res->{name},
      password   => 'twitter',
      address    => $res->{location},
      twitter_id => $res->{id},
    };
    my $txn_scope = $self->txn_scope;
    my $result = try {
      $self->users->add_row($params);
      right 1;
    } catch {
      my $e = $_;
      $txn_scope->rollback;
      left do {
        # エラーメッセージ表示のためにvalidatorの機能を使っている
        my @must_be_change = grep { $e->message =~ /$_/ } qw( id name );
        if (@must_be_change) {
          $self->validator->query({
            id   => [ $res->{screen_name} ],
            name => [ $res->{name} ],
          });
          $self->validator->set_error($_ => 'already_exist') for @must_be_change;
          $self->session->set(ERRORS_SESSION_KEY ,=> $self->validator);
          $self->validator;
        }
        elsif ( $e->message =~ /twitter_id/ ) {
          $self->validator->set_error(twitter_id => 'already_exist');
          $self->session->set(ERRORS_SESSION_KEY ,=> $self->validator);
          $self->validator;
        }
        else {
          $e;
        }
      };
    };
    $result->map(sub { $txn_scope->commit });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

