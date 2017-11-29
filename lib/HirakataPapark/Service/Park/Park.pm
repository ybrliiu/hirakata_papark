package HirakataPapark::Service::Park::Park {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::DB::Schema;

  {
    # park table カラムは全て委譲
    my @fields = HirakataPapark::DB::Schema->context->schema->get_table('park')->get_fields();

    has 'row' => (
      is       => 'ro',
      does     => 'HirakataPapark::DB::Row::Role::Park',
      handles  => [ @fields, qw( size to_json_for_marker park_equipments ) ],
      required => 1,
    );
  }

  has 'park_plants' => (
    is       => 'ro',
    does     => 'HirakataPapark::Model::Role::DB::Parks::Plants',
    required => 1,
  );

  has 'park_equipments' => (
    is       => 'ro',
    does     => 'HirakataPapark::Model::Role::DB::Parks::Equipments',
    required => 1,
  );

  has 'park_facilities' => (
    is       => 'ro',
    does     => 'HirakataPapark::Model::Role::DB::Parks::SurroundingFacilities',
    required => 1,
  );

  has 'plants' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->park_plants->get_rows_by_park_id_order_by_category($self->id)->get_all;
    },
  );

  with 'HirakataPapark::Role::Coord';

  sub plants_categories($self) {
    $self->park_plants->get_categories_by_park_id($self->id);
  }

  sub surrounding_facility_names($self) {
    $self->park_facilities->get_names_by_park_id($self->id);
  }

  sub equipments($self) {
    $self->park_equipments->get_rows_by_park_id($self->id);
  }

  __PACKAGE__->meta->make_immutable();

}

1;

