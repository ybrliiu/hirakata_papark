package HirakataPapark::Model::Parks::Parks {

  use Mouse;
  use HirakataPapark;

  use Smart::Args qw( args );
  
  use constant TABLE => 'park';

  with qw( HirakataPapark::Model::Role::DB );

  around result_class => sub { 'HirakataPapark::Model::Parks::Parks::Result' };

  sub add_row {
    args my $self,
      my $name                 => 'Str',
      my $address              => 'Str',
      my $explain              => { isa => 'Str', default => '' },
      my $remarks_about_plants => { isa => 'Str', default => '' },
      my $good_count           => { isa => 'Int', default => 0 },
      my $x                    => 'Num',
      my $y                    => 'Num',
      my $area                 => 'Num',
      my $is_nice_scenery      => { isa => 'Int', default => 0 },
      my $is_evacuation_area   => { isa => 'Int', default => 0 };

    $self->insert({
      name                 => $name,
      address              => $address,
      explain              => $explain,
      remarks_about_plants => $remarks_about_plants,
      good_count           => $good_count,
      x                    => $x,
      y                    => $y,
      area                 => $area,
      is_nice_scenery      => $is_nice_scenery,
      is_evacuation_area   => $is_evacuation_area,
    });
  }

  sub add_rows($self, $hash_list) {
    $self->insert_multi($hash_list);
  }

  sub get_row_by_id($self, $id) {
    $self->select({id => $id})->first_with_option;
  }

  sub get_row_by_name($self, $name) {
    $self->select({name => $name})->first_with_option;
  }

  sub get_rows_like_name($self, $name) {
    $self->result_class->new([ $self->select({name => {like => "%${name}%"}})->all ]);
  }

  sub get_rows_like_address($self, $address) {
    $self->result_class->new([ $self->select({address => {like => "%${address}%"}})->all ]);
  }

  sub get_rows_by_id_list($self, $id_list) {
    $self->result_class->new([ $self->select({id => {IN => $id_list}})->all ]);
  }

  sub get_rows_by_equipments_names($self, $names) {
    my @name_condition = map { ('=', $_) } @$names;
    my @equipments = $self->db->select('park_equipment', {name => \@name_condition}, {prefetch => ['park']})->all;
    $self->result_class->new([ map { $_->park } @equipments ]);
  }

  __PACKAGE__->meta->make_immutable;

}

package HirakataPapark::Model::Parks::Parks::Result {

  use Mouse;
  use HirakataPapark;
  use Option;

  extends qw( HirakataPapark::Model::Result );

  has 'id_map' => (
    is      => 'ro',
    isa     => 'HashRef[HirakataPapark::DB::Row]',
    lazy    => 1,
    builder => '_build_id_map',
  );

  sub _build_id_map($self) {
    +{ map { $_->id => $_ } $self->contents->@* };
  }

  sub get_by_id($self, $id) {
    option $self->id_map->{$id}
  }

  sub to_json_for_marker {
    my $self = shift;
    "[ " . (join ", ", map { $_->to_json_for_marker } $self->contents->@*) . " ]";
  }

  __PACKAGE__->meta->make_immutable;

}

1;

