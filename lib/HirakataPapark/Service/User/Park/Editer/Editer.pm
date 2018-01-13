package HirakataPapark::Service::User::Park::Editer::Editer {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use Either;
  use Try::Tiny;
  use aliased 'HirakataPapark::Service::User::Park::Editer::MessageData';
  use aliased 'HirakataPapark::Service::User::Park::Editer::ValidatorsContainer';
  use aliased 'HirakataPapark::Model::Users::ParkEditHistories::Park::LangRecord';
  use aliased 'HirakataPapark::Model::Users::ParkEditHistories::History::LangRecords';
  use aliased 'HirakataPapark::Model::Users::ParkEditHistories::Park::Park';
  use aliased 'HirakataPapark::Model::Users::ParkEditHistories::History::History::HasOne::ToAdd' => 'History';

  use constant {
    DEFAULT_LANG  => HirakataPapark::Types->DEFAULT_LANG,
    FOREIGN_LANGS => HirakataPapark::Types->FOREIGN_LANGS,
  };

  has 'lang' => ( is => 'ro', isa => 'HirakataPapark::Types::Lang', required => 1 );

  has 'user' => (
    is       => 'ro',
    isa      => 'HirakataPapark::DB::Row::User',
    required => 1,
  );

  has 'parks_model_delegator' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::MultilingualDelegator::Parks::Parks',
    required => 1,
  );

  has 'histories_model' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Users::ParkEditHistories::Park',
    required => 1,
  );

  has 'json' => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
  );

  has 'message_data' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Validator::MessageData',
    lazy    => 1,
    builder => '_build_message_data',
  );

  has 'validators_container' => (
    is      => 'ro',
    isa     => ValidatorsContainer,
    lazy    => 1,
    builder => '_build_validators_container',
  );

  with 'HirakataPapark::Service::Role::DB';

  sub _build_message_data($self) {
    MessageData->instance->message_data($self->lang);
  }

  sub _build_validators_container($self) {
    ValidatorsContainer->new({
      json         => $self->json,
      message_data => $self->message_data,
    });
  }

  sub can_park_edit($self) {
    $self->user->can_edit_park # && !$self->park->is_locked;
  }

  sub update($self, $params_container) {
    my $parks_model = 
      $self->parks_model_delegator->model(HirakataPapark::Types->DEFAULT_LANG);
    my $park_id = $params_container->body->param('park_id')->get;
    my $params = {
      do {
        my %body_params = $params_container->body->to_hash->%*;
        delete $body_params{park_id};
        %body_params;
      },
      $params_container->get_sub_params(DEFAULT_LANG)->get->to_hash->%*,
    };
    $parks_model->update($params, { id => $park_id });
    for my $lang (FOREIGN_LANGS->@*) {
      $params_container->get_sub_params($lang)->map(sub ($params) {
        my $model = $self->parks_model_delegator->model($lang);
        $model->update($params->to_hash, { id => $park_id });
      });
    }
  }

  sub add_edit_history($self, $params_container) {
    my $body_params = $params_container->body->to_hash;
    my $default_lang_record =
      LangRecord->new( $params_container->get_sub_params(DEFAULT_LANG)->get->to_hash );
    my $park = Park->new({
      %$body_params{ Park->COLUMN_NAMES->@* },
      lang_records => LangRecords->new({
        DEFAULT_LANG ,=> $default_lang_record,
        (
          map {
            my $lang = $_;
            $params_container->get_sub_params($lang)->match(
              Some => sub ($params) { $lang => LangRecord->new($params->to_hash) },
              None => sub { () },
            );
          } FOREIGN_LANGS->@*
        ),
      }),
    });
    my $history = History->new({
      ( 
        map {
          my $attr_name = $_;
          exists $body_params->{$attr_name} ? ($attr_name => $body_params->{$attr_name}) : ()
        } History->COLUMN_NAMES->@*
      ),
      editer_seacret_id => $self->user->seacret_id,
      item_impl         => $park,
    });
    $self->histories_model->add_history($history);
  }

  # -> Either[ Params | Validator | Exception ]
  sub edit($self) {
    $self->validators_container->validate->flat_map(sub ($params_container) {
      if ( $self->can_park_edit ) {
        my $txn_scope = $self->txn_scope;
        my $result = try {
          $self->update($params_container);
          $self->add_edit_history($params_container);
        } catch {
          $txn_scope->rollback;
          left $_;
        };
        $result->map(sub { $txn_scope->commit });
      } else {
        left "Cant edit park ( user cant edit park or the park is locked. )";
      }
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

