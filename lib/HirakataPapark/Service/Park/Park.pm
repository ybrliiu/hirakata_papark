package HirakataPapark::Service::Park::Park {

  use Mouse;
  use HirakataPapark;
  use Mojo::Util qw( camelize );
  use HirakataPapark::DB::Schema;
  use HirakataPapark::Service::Park::ImagesJSONGenerator;

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

  for my $name (qw/ tags stars images /) {
    my $accessor_name = $name . '_model';
    my $class_name    = 'HirakataPapark::Model::Parks::' . ucfirst $name;
    has $accessor_name => (
      is       => 'ro',
      isa      => $class_name,
      required => 1,
    );
  }

  for my $name (qw/ plants equipments surrounding_facilities /) {
    my $accessor_name = $name . '_model';
    my $role_name     = 'HirakataPapark::Model::Role::DB::Parks::' . camelize $name;
    has $accessor_name => (
      is       => 'ro',
      does     => $role_name,
      required => 1,
    );
  }

  has 'plants' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    lazy    => 1,
    default => sub ($self) {
      $self->park_plants->get_rows_by_park_id_order_by_category($self->id)->get_all;
    },
  );

  has 'static_path' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  has 'images_json_generator' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Service::Park::ImagesJSONGenerator',
    lazy    => 1,
    handles => { images_json => 'generate' },
    builder => '_build_images_json_generator',
  );

  with 'HirakataPapark::Role::Coord';

  sub _build_images_json_generator($self) {
    HirakataPapark::Service::Park::ImagesJSONGenerator->new({
      park_id     => $self->id,
      images      => $self->images,
      static_path => $self->static_path,
    });
  }

  sub plants_categories($self) {
    $self->plants_model->get_categories_by_park_id($self->id);
  }

  sub surrounding_facility_names($self) {
    $self->surrounding_facilities_model->get_names_by_park_id($self->id);
  }

  sub equipments($self) {
    $self->equipments_model->get_rows_by_park_id($self->id);
  }

  sub tags($self) {
    $self->tags_model->get_rows_by_park_id($self->id);
  }

  sub stars($self) {
    $self->stars_model->get_rows_by_park_id($self->id);
  }

  sub images($self) {
    $self->images_model->get_rows_by_park_id($self->id);
  }

  __PACKAGE__->meta->make_immutable;

}

1;
