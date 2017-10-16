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

  has 'park_equipments_model' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Parks::Equipments',
    lazy    => 1,
    default => sub ($self) { $self->model('Parks::Equipments')->new },
  );

  has 'park_surrounding_facilities_model' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Parks::SurroundingFacilities',
    lazy    => 1,
    default => sub ($self) { $self->model('Parks::SurroundingFacilities')->new },
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
    my $id_list = $self->park_equipments_model->get_park_id_list_has_names($names);
    my $parks   = [ $self->parks_model->select({id => {IN => $id_list}})->all ];
    return +{ parks => $parks };
  }

  sub has_surrounding_facilities($self, $names = []) {
    my $id_list = $self->park_surrounding_facilities_model->get_park_id_list_has_names($names);
    my $parks   = [ $self->parks_model->select({id => {IN => $id_list}})->all ];
    return +{ parks => $parks };
  }

  __PACKAGE__->meta->make_immutable;

}

1;

