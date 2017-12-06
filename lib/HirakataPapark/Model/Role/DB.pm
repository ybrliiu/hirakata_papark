package HirakataPapark::Model::Role::DB {

  use Mouse::Role;
  use HirakataPapark;

  use HirakataPapark::DB;
  use HirakataPapark::Exception;
  use HirakataPapark::Model::Config;
  use HirakataPapark::Model::Result;

  requires qw( TABLE );

  sub db;
  has 'db' => ( is => 'ro', isa => 'HirakataPapark::DB', default => \&default_db );

  sub default_db($class) {
    state $db;
    return $db if defined $db;
    HirakataPapark::Model::Config->instance->get_config('db')->match(
      Some => sub ($config) { $db = HirakataPapark::DB->new(%$config) },
      None => sub { HirakataPapark::Exception->throw('db config data is not exists.') },
    );
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
    $self->result_class->new([ $self->select({})->all ]);
  }

  sub txn_scope($self) {
    $self->db->handler->txn_manager->txn_scope;
  }

  sub update($self, $set, $where) {
    $self->db->update($self->TABLE, $set, $where);
  }

}

1;

