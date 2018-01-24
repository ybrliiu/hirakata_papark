package HirakataPapark::Model::Role::DB {

  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::DB;
  use HirakataPapark::Model::Result;

  sub db;
  has 'db' => (
    is       => 'ro',
    isa      => 'HirakataPapark::DB',
    required => 1,
  );

  sub txn_scope($self) {
    $self->db->handler->txn_manager->txn_scope;
  }

  sub create_result($self, $contents) {
    HirakataPapark::Model::Result->new(contents => $contents);
  }

}

1;

