package HirakataPapark::Model::Role::DB::Parks::Equipments {

  use Mouse::Role;
  use HirakataPapark;

  sub get_row_by_park_id_and_name($self, $park_id, $name) {
    $self->select({
      $self->TABLE . '.park_id' => $park_id,
      $self->TABLE . '.name'    => $name,
    })->first_with_option;
  }

  sub get_equipment_list($self) {
    my @equipment_list =
      map { $_->name } $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => [$self->TABLE . '.name'] } )->all;
    \@equipment_list;
  }

}

1;
