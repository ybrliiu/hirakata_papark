package HirakataPapark::Service::User::Park::Tagger::Tagger {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use Either;
  use Try::Tiny;
  use HirakataPapark::Validator::DefaultMessageData;
  use HirakataPapark::Service::User::Park::Tagger::Validator;

  has 'lang' => ( is => 'ro', isa => 'HirakataPapark::Types::Lang', required => 1 );

  has 'params' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Validator::Params',
    required => 1,
  );

  has 'park_tags' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Parks::Tags',
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
    isa     => 'HirakataPapark::Service::User::Park::Tagger::Validator',
    lazy    => 1,
    builder => '_build_validator',
  );

  with 'HirakataPapark::Service::Role::DB';

  sub _build_validator($self) {
    HirakataPapark::Service::User::Park::Tagger::Validator->new({
      params       => $self->params,
      message_data => $self->message_data,
    });
  }

  sub add_tag($self) {
    $self->validator->validate->flat_map(sub ($params) {
      my $txn_scope = $self->txn_scope;
      my $either = try {
        $self->park_tags->add_row({
          park_id  => $params->param('park_id')->get,
          name     => $params->param('tag_name')->get,
        });
        right 1;
      } catch {
        my $e = $_;
        $txn_scope->rollback;
        if ( HirakataPapark::DB::DuplicateException->caught($e) ) {
          my $v = $self->validator;
          $v->set_error(tag_name => 'already_exist');
          left $v;
        } else {
          left $e;
        }
      };
      $either->map(sub { $txn_scope->commit });
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

