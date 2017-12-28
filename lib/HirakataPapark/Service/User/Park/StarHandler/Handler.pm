package HirakataPapark::Service::User::Park::StarHandler::Handler {

  use Mouse;
  use HirakataPapark;
  use Either;
  use Try::Tiny;
  use HirakataPapark::Validator::DefaultMessageData;
  use HirakataPapark::Service::User::Park::StarHandler::Validator;

  has 'lang' => ( is => 'ro', isa => 'HirakataPapark::lang', required => 1 );

  has 'params' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Validator::Params',
    required => 1,
  );

  has 'user' => (
    is       => 'ro',
    isa      => 'HirakataPapark::DB::Row',
    required => 1,
  );

  has 'park_stars' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Parks::Stars',
    required => 1,
  );

  has 'message_data' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Validator::MessageData',
    lazy    => 1,
    default => sub ($self) {
      HirakataPapark::Validator::DefaultMessageData->instance->message_data($self->lang)
    },
  );

  has 'validator' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Service::User::Park::StarHandler::Validator',
    lazy    => 1,
    builder => '_build_validator',
  );

  with 'HirakataPapark::Service::Role::DB';

  sub _build_validator($self) {
    HirakataPapark::Service::User::Park::StarHandler::Validator->new({
      params       => $self->params,
      message_data => $self->message_data,
    });
  }

  sub add_star($self) {
    $self->validator->validate->flat_map(sub ($park_id) {
      my $txn_scope = $self->txn_scope;
      my $either = try {
        $self->park_stars->add_row({
          park_id         => $park_id,
          user_seacret_id => $self->user->seacret_id,
        });
        right 1;
      } catch {
        $txn_scope->rollback;
        # 詳細なエラーメッセージを返したいなら、例外の内容をみて
        # $self->validator にエラーメッセージをセットするといいかもしれない
        left $_;
      };
      $either->map(sub { $txn_scope->commit });
    });
  }

  sub remove_star($self) {
    $self->validator->validate->flat_map(sub ($park_id) {
      my $txn_scope = $self->txn_scope;
      my $either = try {
        $self->park_stars->delete({
          park_id         => $park_id,
          user_seacret_id => $self->user->seacret_id,
        });
        right 1;
      } catch {
        $txn_scope->rollback;
        left $_;
      };
      $either->map(sub { $txn_scope->commit });
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

