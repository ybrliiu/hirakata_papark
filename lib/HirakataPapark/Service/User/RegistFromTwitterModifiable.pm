package HirakataPapark::Service::User::RegistFromTwitterModifiable {

  use Mouse;
  use HirakataPapark;
  use Option;
  use Either;
  use Try::Tiny;
  extends qw( HirakataPapark::Service::User::Regist::Register );

  with qw( HirakataPapark::Service::User::Role::UseTwitterAPI );

  override _build_validator => sub ($self) {
    $self->params->set(password => '0_twitter_twitter');
    super;
  };

  # Either[ Bool | Validator | Exception ]
  override regist => sub ($self) {
    $self->validator->validate->flat_map(sub {
      my $res    = $self->api_caller->account_verify_credentials;
      my $params = $self->params->to_hash;
      $params->{twitter_id} = $res->{id};
      my $txn_scope = $self->txn_scope;
      my $result = try {
        $self->users->add_row($params);
        right 1;
      } catch {
        $txn_scope->rollback;
        left $_;
      };
      $result->map(sub { $txn_scope->commit });
    });
  };

  __PACKAGE__->meta->make_immutable;

}

1;

