package HirakataPapark::Service::Role::DB {

  use Mouse::Role;
  use HirakataPapark;

  has 'db' => (
    is       => 'ro',
    isa      => 'HirakataPapark::DB',
    required => 1,
  );

  sub txn_scope($self) {
    $self->db->handler->txn_manager->txn_scope;
  }

}

1;

