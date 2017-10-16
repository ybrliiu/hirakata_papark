package HirakataPapark::Service::Searcher {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Service::Service';

  sub equipment {
    my $self = shift;
    my $equipments_model = $self->model('Parks::Equipments')->new;
    return +{ equipment_list => $equipments_model->get_equipment_list };
  }

  sub surrounding_facility {
    my $self = shift;
    my $facilities_model = $self->model('Parks::SurroundingFacilities')->new;
    return +{ surrounding_facility_list => $facilities_model->get_surrounding_facility_list };
  }

  __PACKAGE__->meta->make_immutable;

}

1;

