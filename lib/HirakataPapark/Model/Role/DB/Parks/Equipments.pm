package HirakataPapark::Model::Role::DB::Parks::Equipments {

  use Mouse::Role;
  use HirakataPapark;

  # methods
  requires qw( get_equipment_list );

}

1;
