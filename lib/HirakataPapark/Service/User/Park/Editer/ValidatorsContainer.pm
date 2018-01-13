package HirakataPapark::Service::User::Park::Editer::ValidatorsContainer {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use HirakataPapark::Util qw( for_yield );
  use aliased 'HirakataPapark::Service::User::Park::Editer::Validator';
  use aliased 'HirakataPapark::Service::User::Park::Editer::LangRecordValidator';
  use namespace::autoclean;

  use constant {
    DEFAULT_LANG  => HirakataPapark::Types->DEFAULT_LANG,
    FOREIGN_LANGS => HirakataPapark::Types->FOREIGN_LANGS,
  };

  with 'HirakataPapark::Validator::JSON::ValidatorsContainer';

  sub _build_body($self) {
    Validator->new({
      params       => $self->params_container->body,
      message_data => $self->message_data,
    });
  }

  sub _build_sub_validators_mapped($self) {
    my %map = (
      DEFAULT_LANG ,=>
        $self->_maybe_create_sub_validator(DEFAULT_LANG)->get_or_else(+{}), 
      ( map {
        my $lang = $_;
        $self->_maybe_create_sub_validator($lang)->match(
          Some => sub ($validator) { $lang => $validator },
          None => sub { () },
        );
      } FOREIGN_LANGS->@* ),
    );
    \%map;
  }

  sub _maybe_create_sub_validator($self, $name) {
    $self->params->get_sub_params($name)->map(sub ($params) {
      LangRecordValidator->new({
        params       => $params,
        message_data => $self->message_data,
      });
    });
  }

  sub validate($self) {
    my @validators_results = (
      $self->body->validate,
      $self->get_sub_validator(DEFAULT_LANG)->get->validate,
      ( map { $self->get_sub_validator($_)->get->validate } FOREIGN_LANGS->@* ),
    );
    for_yield(\@validators_results, sub {
      $self->params_container;
    })->match(
      Right => sub ($params_container) { right $params_container },
      Left  => sub { left $self },
    );
  }

  __PACKAGE__->meta->make_immutable;

}

1;
