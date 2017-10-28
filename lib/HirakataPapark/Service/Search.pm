package HirakataPapark::Service::Search {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Service::Service';

  has 'parks' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Parks',
    lazy    => 1,
    default => sub ($self) { $self->model('Parks')->new },
  );

  has 'park_tags' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Parks::Tags',
    lazy    => 1,
    default => sub ($self) { $self->model('Parks::Tags')->new },
  );

  has 'park_plants' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Parks::Plants',
    lazy    => 1,
    default => sub ($self) { $self->model('Parks::Plants')->new },
  );

  has 'park_equipments' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Parks::Equipments',
    lazy    => 1,
    default => sub ($self) { $self->model('Parks::Equipments')->new },
  );

  has 'park_surrounding_facilities' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Parks::SurroundingFacilities',
    lazy    => 1,
    default => sub ($self) { $self->model('Parks::SurroundingFacilities')->new },
  );

  sub like_name($self, $name) {
    return +{ parks => $self->parks->get_rows_like_name($name) };
  }

  sub like_english_name($self, $name) {
    return +{ parks => $self->parks->get_rows_like_english_name($name) };
  }

  sub like_address($self, $address) {
    return +{ parks => $self->parks->get_rows_like_address($address) };
  }

  sub like_english_address($self, $address) {
    return +{ parks => $self->parks->get_rows_like_english_address($address) };
  }

  sub by_equipments($self, $names) {
    return +{ parks => $self->parks->get_rows_by_equipments_names($names) };
  }

  sub has_tags($self, $names) {
    my $id_list = $self->park_tags->get_park_id_list_has_names($names);
    my $parks   = [ $self->parks->select({id => {IN => $id_list}})->all ];
    return +{ parks => $parks };
  }

  sub has_plants($self, $names) {
    my $id_list = $self->park_plants->get_park_id_list_has_names($names);
    my $parks   = [ $self->parks->select({id => {IN => $id_list}})->all ];
    return +{ parks => $parks };
  }

  sub has_plants_english($self, $names) {
    my $id_list = $self->park_plants->get_park_id_list_has_english_names($names);
    my $parks   = [ $self->parks->select({id => {IN => $id_list}})->all ];
    return +{ parks => $parks };
  }

  sub has_plants_categories($self, $category_names) {
    my $id_list = $self->park_plants->get_park_id_list_has_category_names($category_names);
    my $parks   = [ $self->parks->select({id => {IN => $id_list}})->all ];
    return +{ parks => $parks };
  }

  sub has_plants_categories_english($self, $category_names) {
    my $id_list = $self->park_plants->get_park_id_list_has_english_category_names($category_names);
    my $parks   = [ $self->parks->select({id => {IN => $id_list}})->all ];
    return +{ parks => $parks };
  }

  sub has_equipments($self, $names) {
    my $id_list = $self->park_equipments->get_park_id_list_has_names($names);
    my $parks   = [ $self->parks->select({id => {IN => $id_list}})->all ];
    return +{ parks => $parks };
  }

  sub has_equipments_english($self, $names) {
    my $id_list = $self->park_equipments->get_park_id_list_has_english_names($names);
    my $parks   = [ $self->parks->select({id => {IN => $id_list}})->all ];
    return +{ parks => $parks };
  }

  sub has_surrounding_facilities($self, $names) {
    my $id_list = $self->park_surrounding_facilities->get_park_id_list_has_names($names);
    my $parks   = [ $self->parks->select({id => {IN => $id_list}})->all ];
    return +{ parks => $parks };
  }

  sub has_surrounding_facilities_english($self, $names) {
    my $id_list = $self->park_surrounding_facilities->get_park_id_list_has_english_names($names);
    my $parks   = [ $self->parks->select({id => {IN => $id_list}})->all ];
    return +{ parks => $parks };
  }

  __PACKAGE__->meta->make_immutable;

}

1;

