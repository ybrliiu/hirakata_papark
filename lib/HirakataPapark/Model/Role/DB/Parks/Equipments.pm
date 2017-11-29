package HirakataPapark::Model::Role::DB::Parks::Equipments {

  use Mouse::Role;
  use HirakataPapark;

  sub get_equipment_list($self) {
    my @equipment_list =
      map { $_->name } $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => [$self->TABLE . '.name'] } )->all;
    \@equipment_list;
  }

}

1;
