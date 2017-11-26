package HirakataPapark::Model::Role::DB {

  use Mouse::Role;
  use HirakataPapark;

  use HirakataPapark::DB;
  use HirakataPapark::Model::Config;
  use HirakataPapark::Model::Result;

  requires qw( TABLE );

  has 'db' => ( is => 'ro', isa => 'HirakataPapark::DB', default => \&default_db );

  sub default_db($class) {
    state $db;
    return $db if defined $db;

    if ($ENV{HARNESS_ACTIVE}) {
      my ($dsn, $user) = ($ENV{TEST_POSTGRESQL}, $ENV{TEST_POSTGRESQL_USER});
      $db = HirakataPapark::DB->new(connect_info => [$dsn, $user]);
    } else {
      my $config = HirakataPapark::Model::Config->get->{db};
      $db = HirakataPapark::DB->new(%$config);
    }
  }

  sub result_class { 'HirakataPapark::Model::Result' }

  sub insert {
    my $self = shift;
    $self->db->insert($self->TABLE => @_);
  }
  
  sub insert_multi {
    my $self = shift;
    $self->db->insert_multi($self->TABLE => @_);
  }

  sub select {
    my $self = shift;
    $self->db->select($self->TABLE => @_);
  }

  sub get_rows_all($self) {
    $self->result_class->new([ $self->db->select($self->TABLE => {})->all ]);
  }

  sub txn_scope($self) {
    $self->db->handler->txn_manager->txn_scope;
  }

}

1;

