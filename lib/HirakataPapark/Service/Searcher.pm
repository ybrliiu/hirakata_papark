package HirakataPapark::Service::Searcher {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Service::Service';

  sub equipment {
    my $self = shift;
    my $equipments_model = $self->model('Parks::Equipments')->new;
    return +{
      equipment_list => $equipments_model->get_equipment_list,
    };
  }

  __PACKAGE__->meta->make_immutable;

}

1;

