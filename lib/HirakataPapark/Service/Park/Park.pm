package HirakataPapark::Service::Park::Park {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::DB::Schema;

  {
    # park table カラムは全て委譲
    my @fields = HirakataPapark::DB::Schema->context->schema->get_table('park')->get_fields();

    has 'row' => (
      is       => 'ro',
      isa      => 'HirakataPapark::DB::Row::Role::Park',
      handles  => [@fields, qw( size to_json_for_marker )],
      required => 1,
    );
  }

  has 'park_plants' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Parks::Parks::Plants',
    required => 1,
  );

  has 'park_facilities' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Parks::Parks::SurroundingFacilities',
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

  sub plants_categories {
    my $self = shift;
    $self->park_plants->get_categories_by_park_id($self->id);
  }

  sub surrounding_facility_names {
    my $self = shift;
    $self->park_facilities->get_names_by_park_id($self->id);
  }

  __PACKAGE__->meta->make_immutable();

}

1;

