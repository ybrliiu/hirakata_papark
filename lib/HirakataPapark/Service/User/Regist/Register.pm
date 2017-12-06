package HirakataPapark::Service::User::Regist::Register {

  use Mouse;
  use HirakataPapark;
  use Either;
  use Try::Tiny;
  use HirakataPapark::Service::User::Regist::Validator;
  use HirakataPapark::Service::User::Regist::MessageData;

  has 'lang' => ( is => 'ro', isa => 'HirakataPapark::lang', required => 1 );

  has 'users' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Users::Users',
    required => 1,
  );

  has 'params' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Validator::Params',
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
    isa     => 'HirakataPapark::Service::User::Regist::Validator',
    lazy    => 1,
    builder => '_build_validator',
  );

  with 'HirakataPapark::Service::Role::DB';

  sub _build_message_data($self) {
    HirakataPapark::Service::User::Regist::MessageData
      ->instance->message_data($self->lang);
  }

  sub _build_validator($self) {
    HirakataPapark::Service::User::Regist::Validator->new({
      users        => $self->users,
      params       => $self->params,
      message_data => $self->message_data,
    });
  }

  # -> Either
  sub regist($self) {
    $self->validator->validate->flat_map(sub {
      my $txn_scope = $self->txn_scope;
      my $result = try {
        $self->users->add_row($self->params->to_hash);
        right 1;
      } catch {
        $txn_scope->rollback;
        left $_;
      };
      $result->map(sub {
        $txn_scope->commit;
        $self->params;
      });
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

