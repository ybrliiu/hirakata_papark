package HirakataPapark::Service::Root {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Service::Service';

  sub root {
    my $self = shift;
    my $park_model = $self->model('Parks')->new;
    $park_model->get_rows_all;
    return +{
      parks_json => $park_model->to_json_for_marker,
    };
  }

}

1;

