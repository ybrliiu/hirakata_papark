package HirakataPapark::Service::Searcher {

  use Mouse;
  use HirakataPapark;
  
  has 'park_plants' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Parks::Plants',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Parks::Plants')->new;
    },
  );
  
  has 'park_equipments' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Parks::Equipments',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Parks::Equipments')->new;
    },
  );

  has 'park_facilities' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Parks::SurroundingFacilities',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Parks::SurroundingFacilities')->new;
    },
  );

  with 'HirakataPapark::Service::Service';

  sub tag {
    my $self = shift;
    my $tags_model = $self->model('Parks::Tags')->new;
    return +{ tag_list => $tags_model->get_tag_list };
  }

  sub plants {
    my $self = shift;
    return +{
      plants_categories  => $self->park_plants->get_category_list,
      categoryzed_plants => $self->park_plants->get_categoryzed_plants_list,
    };
  }

  sub english_plants {
    my $self = shift;
    return +{
      plants_categories  => $self->park_plants->get_english_category_list,
      categoryzed_plants => $self->park_plants->get_english_categoryzed_plants_list,
    };
  }

  sub equipment {
    my $self = shift;
    return +{ equipment_list => $self->park_equipments->get_equipment_list };
  }

  sub english_equipment {
    my $self = shift;
    return +{ equipment_list => $self->park_equipments->get_english_equipment_list };
  }

  sub surrounding_facility {
    my $self = shift;
    return +{ surrounding_facility_list => $self->park_facilities->get_surrounding_facility_list };
  }

  sub english_surrounding_facility {
    my $self = shift;
    return +{ surrounding_facility_list => $self->park_facilities->get_english_surrounding_facility_list };
  }

  __PACKAGE__->meta->make_immutable;

}

1;

