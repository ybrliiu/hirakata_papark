package HirakataPapark::Service::Park::Park {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::DB::Schema;

  use constant {
    WIDE   => 600,
    MIDDLE => 100,
  };

  has 'row' => (
    is       => 'ro',
    isa      => 'HirakataPapark::DB::Row::Park',
    handles  => [qw( to_json_for_marker to_english_json_for_marker park_equipments )],
    required => 1,
  );

  has 'park_plants' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Parks::Plants',
    required => 1,
  );

  has 'park_facilities' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Parks::SurroundingFacilities',
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

  # park table の field のアクセッサ作成
  {
    my @fields = HirakataPapark::DB::Schema->context->schema->get_table('park')->get_fields();
    for my $field (@fields) {
      my $name = $field->name;
      has $name => (
        is      => 'ro',
        lazy    => 1,
        default => sub {
          my $self = shift;
          $self->row->get($name);
        },
      );
    }
  }

  with 'HirakataPapark::Role::Coord';

  sub size {
    my $self = shift;
    if ($self->area >= WIDE) {
      '大';
    } elsif ($self->area >= MIDDLE) {
      '中';
    } else {
      '小';
    }
  }

  sub english_size {
    my $self = shift;
    if ($self->area >= WIDE) {
      'Wide';
    } elsif ($self->area >= MIDDLE) {
      'Middle';
    } else {
      'Narrow';
    }
  }

  sub plants_categories {
    my $self = shift;
    $self->park_plants->get_categories_by_park_id($self->id);
  }

  sub plants_english_categories {
    my $self = shift;
    $self->park_plants->get_english_categories_by_park_id($self->id);
  }

  sub surrounding_facility_names {
    my $self = shift;
    $self->park_facilities->get_names_by_park_id($self->id);
  }

  sub surrounding_facility_english_names {
    my $self = shift;
    $self->park_facilities->get_english_names_by_park_id($self->id);
  }

  __PACKAGE__->meta->make_immutable();

}

1;

