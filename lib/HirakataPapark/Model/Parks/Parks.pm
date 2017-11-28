package HirakataPapark::Model::Parks::Parks {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );
  
  use constant TABLE => 'park';

  with qw(
    HirakataPapark::Model::Role::DB
    HirakataPapark::Model::Role::DB::Parks::Parks
  );

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

  __PACKAGE__->meta->make_immutable;

}

1;

