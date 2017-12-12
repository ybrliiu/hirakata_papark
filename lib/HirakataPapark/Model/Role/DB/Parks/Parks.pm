package HirakataPapark::Model::Role::DB::Parks::Parks {

  use Mouse::Role;
  use HirakataPapark;

  use HirakataPapark::Model::Parks::ParksResult;

  # methods
  requires qw( add_row );

  around result_class => sub { 'HirakataPapark::Model::Parks::ParksResult' };

  sub add_rows($self, $hash_list) {
    $self->insert_multi($hash_list);
  }

  sub get_row_by_id($self, $id) {
    $self->select({ $self->TABLE . '.id' => $id })->first_with_option;
  }

  sub get_row_by_name($self, $name) {
    $self->select({ $self->TABLE . '.name' => $name })->first_with_option;
  }

  sub get_rows_like_name($self, $name) {
    $self->result_class->new([ $self->select({ $self->TABLE . '.name' => {like => "%${name}%"} })->all ]);
  }

  sub get_rows_like_address($self, $address) {
    $self->result_class->new([ $self->select({ $self->TABLE . '.address' => {like => "%${address}%"}})->all ]);
  }

  sub get_rows_by_id_list($self, $id_list = []) {
    $self->result_class->new([ $self->select({ $self->TABLE . '.id' => $id_list })->all ]);
  }

  sub _get_stared_rows_by_user_seacret_id_sql($self, $user_seacret_id) {
    my $select = $self->db->query_builder->new_select;
    $select->add_select('*');
    $select->add_where('park_star.user_seacret_id' => $user_seacret_id);
    $select->add_join(park_star => {
      type      => 'inner',
      table     => 'park',
      condition => 'park.id = park_star.park_id',
    });
    $select;
  }

  sub get_stared_rows_by_user_seacret_id($self, $user_seacret_id) {
    my $select = $self->_get_stared_rows_by_user_seacret_id_sql($user_seacret_id);
    $self->result_class->new([ $self->db->select_by_sql($select->as_sql, [$select->bind], {})->all ]);
  }

}

1;

