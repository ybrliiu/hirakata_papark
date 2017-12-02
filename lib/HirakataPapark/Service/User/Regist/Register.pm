package HirakataPapark::Service::User::Regist::Register {

  use Mouse;
  use HirakataPapark;
  use Either;
  use Try::Tiny;

  has 'validator' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Service::User::Regist::Validator',
    handles  => [qw( users params )],
    required => 1,
  );

  with 'HirakataPapark::Service::Role::DB';

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

