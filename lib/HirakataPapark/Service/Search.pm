package HirakataPapark::Service::Search {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Service::Service';

  has 'parks_model' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Parks',
    lazy    => 1,
    default => sub ($self) { $self->model('Parks')->new },
  );

  sub like_name($self, $name) {
    return +{ parks => $self->parks_model->get_rows_like_name($name) };
  }

  sub like_address($self, $address) {
    return +{ parks => $self->parks_model->get_rows_like_address($address) };
  }

  sub by_equipments($self, $names = []) {
    return +{ parks => $self->parks_model->get_rows_by_equipments_names($names) };
  }

  sub has_equipments($self, $names = []) {
    return +{ parks => $self->parks_model->get_rows_has_equipments_names($names) };
  }

  __PACKAGE__->meta->make_immutable;

}

1;

