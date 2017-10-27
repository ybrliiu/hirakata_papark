package HirakataPapark::Model::Parks {

  use Mouse;
  use HirakataPapark;

  use Smart::Args qw( args args_pos );
  
  use constant TABLE => 'park';

  with 'HirakataPapark::Model::Role::DB';

  sub add_row {
    args my $self,
      my $name                 => 'Str',
      my $english_name         => 'Str',
      my $address              => 'Str',
      my $english_address      => 'Str',
      my $explain              => { isa => 'Str', default => '' },
      my $english_explain      => { isa => 'Str', default => '' },
      my $remarks_about_plants => { isa => 'Str', default => '' },
      my $good_count           => { isa => 'Int', default => 0 },
      my $x                    => 'Num',
      my $y                    => 'Num',
      my $area                 => 'Num',
      my $is_nice_scenery      => { isa => 'Int', default => 0 },
      my $is_evacuation_area   => { isa => 'Int', default => 0 };

    $self->insert({
      name                 => $name,
      english_name         => $english_name,
      address              => $address,
      english_address      => $english_address,
      explain              => $explain,
      english_explain      => $english_explain,
      remarks_about_plants => $remarks_about_plants,
      good_count           => $good_count,
      x                    => $x,
      y                    => $y,
      area                 => $area,
      is_nice_scenery      => $is_nice_scenery,
      is_evacuation_area   => $is_evacuation_area,
    });
  }

  sub add_rows {
    args_pos my $self, my $hash_list => 'ArrayRef[HashRef]';
    $self->insert_multi($hash_list);
  }

  sub get_row_by_id {
    args_pos my $self, my $id => 'Int';
    $self->select({id => $id})->first_with_option;
  }

  sub get_row_by_name {
    args_pos my $self, my $name => 'Str';
    $self->select({name => $name})->first_with_option;
  }

  sub get_rows_like_name($self, $name) {
    [ $self->select({name => {like => "%${name}%"}})->all ];
  }

  sub get_rows_like_address($self, $address) {
    [ $self->select({address => {like => "%${address}%"}})->all ];
  }

  # いらない or いるとしたらここにあるべきメソッドでない(park_equipment)
  sub get_rows_by_equipments_names {
    args_pos my $self, my $names => 'ArrayRef[Str]';
    my @name_condition = map { ('=', $_) } @$names;
    my @equipments = $self->db->select('park_equipment', {name => \@name_condition}, {prefetch => ['park']})->all;
    [ map { $_->park } @equipments ];
  }

  # 結果を park map の marker のための json にするので、 先に何らかのメソッドで結果を取得しておくこと
  sub to_json_for_marker {
    my $self = shift;
    return '[]' unless $self->result;
    "[ " . (join ", ", map { $_->to_json_for_marker } $self->result->all) . " ]";
  }

  __PACKAGE__->meta->make_immutable;

}

1;

