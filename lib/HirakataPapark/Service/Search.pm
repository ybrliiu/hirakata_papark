package HirakataPapark::Service::Search {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Service::Service';

  sub by_equipments {
    my ($self, $names) = @_;
    $names //= [];
    my $parks_model = $self->model('Parks')->new;
    return +{
      parks => $parks_model->get_rows_by_equipments_names($names),
    };
  }

  sub has_equipments {
    my ($self, $names) = @_;
    $names //= [];
    my $parks_model = $self->model('Parks')->new;
    return +{
      parks => $parks_model->get_rows_has_equipments_names($names),
    };
  }

  __PACKAGE__->meta->make_immutable;

}

1;

