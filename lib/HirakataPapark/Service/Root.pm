package HirakataPapark::Service::Root {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Service::Service';

  sub root {
    my $self = shift;
    return +{
      parks => $self->model('Parks')->new->get_rows_all,
    };
  }

}

1;

