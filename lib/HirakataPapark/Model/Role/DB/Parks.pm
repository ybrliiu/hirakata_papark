package HirakataPapark::Model::Role::DB::Parks {

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
    $self->select({id => $id})->first_with_option;
  }

  sub get_row_by_name($self, $name) {
    $self->select({name => $name})->first_with_option;
  }

  sub get_rows_like_name($self, $name) {
    $self->result_class->new([ $self->select({name => {like => "%${name}%"}})->all ]);
  }

  sub get_rows_like_address($self, $address) {
    $self->result_class->new([ $self->select({address => {like => "%${address}%"}})->all ]);
  }

  sub get_rows_by_id_list($self, $id_list) {
    $self->result_class->new([ $self->select({id => {IN => $id_list}})->all ]);
  }

  sub get_rows_by_equipments_names($self, $names) {
    my @name_condition = map { ('=', $_) } @$names;
    my @equipments = $self->db->select('park_equipment', {name => \@name_condition}, {prefetch => ['park']})->all;
    $self->result_class->new([ map { $_->park } @equipments ]);
  }

}

1;

