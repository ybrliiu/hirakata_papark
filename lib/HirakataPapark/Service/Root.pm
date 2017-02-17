package HirakataPapark::Service::Root {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Service::Service';

  use HirakataPapark::Model::Parks;

  sub root {
    my $self = shift;
    my $model = HirakataPapark::Model::Parks->new;
    return { parks => $model->get_rows_all };
  }

}

1;

