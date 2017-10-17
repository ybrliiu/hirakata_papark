package HirakataPapark::Service::Searcher {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Service::Service';

  sub tag {
    my $self = shift;
    my $tags_model = $self->model('Parks::Tags')->new;
    return +{ tag_list => $tags_model->get_tag_list };
  }

  sub plants {
    my $self = shift;
    my $plants_model = $self->model('Parks::Plants')->new;
    return +{
      plants_categories  => $plants_model->get_category_list,
      categoryzed_plants => $plants_model->get_categoryzed_plants_list,
    };
  }

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

