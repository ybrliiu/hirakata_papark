package HirakataPapark::Model::Role::DB::RowHandler {

  use Mouse::Role;
  use HirakataPapark;

  with 'HirakataPapark::Model::Role::DB';

  # constants
  requires qw( HANDLE_TABLE_NAME );

  sub delete($self, $where) {
    $self->db->delete($self->HANDLE_TABLE_NAME, $where);
  }

  sub insert {
    my $self = shift;
    $self->db->insert($self->HANDLE_TABLE_NAME => @_);
  }
  
  sub insert_multi {
    my $self = shift;
    $self->db->insert_multi($self->HANDLE_TABLE_NAME => @_);
  }

  sub select {
    my $self = shift;
    $self->db->select($self->HANDLE_TABLE_NAME => @_);
  }

  sub get_rows_all($self) {
    $self->create_result($self->select({})->rows);
  }

  sub update($self, $set, $where) {
    $self->db->update($self->HANDLE_TABLE_NAME, $set, $where);
  }

}

1;
