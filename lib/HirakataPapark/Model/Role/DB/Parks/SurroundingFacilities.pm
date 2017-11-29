package HirakataPapark::Model::Role::DB::Parks::SurroundingFacilities {

  use Mouse::Role;
  use HirakataPapark;

  # method
  requires qw(
    get_names_by_park_id
    get_surrounding_facility_list
  );

}

1;


