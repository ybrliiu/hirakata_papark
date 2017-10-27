package HirakataPapark::Model::Role::DB {

  use Mouse::Role;
  use HirakataPapark;

  use HirakataPapark::DB;
  use HirakataPapark::Model::Config;

  requires 'TABLE';

  has 'db'     => ( is => 'ro', isa => 'HirakataPapark::DB', default => \&default_db );
  has 'result' => ( is => 'rw', isa => 'HirakataPapark::DB::Result' );

  sub default_db {
    my $class = shift;
    
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
    my $result = $self->db->select($self->TABLE => @_);
    $self->result($result);
  }

  sub get_rows_all {
    my $self = shift;
    $self->result( $self->db->select($self->TABLE => {}) );
    [ $self->result->all ];
  }

  sub txn_scope {
    my $self = shift;
    $self->db->handler->txn_manager->txn_scope;
  }

}

1;

