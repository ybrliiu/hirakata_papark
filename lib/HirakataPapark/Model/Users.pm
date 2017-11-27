package HirakataPapark::Model::Users {

  use Mouse;
  use HirakataPapark;

  use Smart::Args qw( args );
  
  use constant TABLE => 'user';

  with qw( HirakataPapark::Model::Role::DB );

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

  sub get_row_by_seacret_id($self, $seacret_id) {
    $self->select({seacret_id => $seacret_id})->first_with_option;
  }

  sub get_row_by_id($self, $id) {
    $self->select({id => $id})->first_with_option;
  }

  sub get_row_by_name($self, $name) {
    $self->select({name => $name})->first_with_option;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

