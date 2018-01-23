package HirakataPapark::Model::Parks::Parks {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );
  
  use constant HANDLE_TABLE_NAME => 'park';

  with qw(
    HirakataPapark::Model::Role::DB::RowHandler
    HirakataPapark::Model::Role::DB::Parks::Parks
  );

  sub add_row {
    args my $self, my $name => 'Str',
      my $zipcode            => 'Str',
      my $address            => 'Str',
      my $explain            => { isa => 'Str', default => '' },
      my $x                  => 'Num',
      my $y                  => 'Num',
      my $area               => 'Num',
      my $is_locked          => { isa => 'Bool', default => 0 },
      my $is_evacuation_area => { isa => 'Int', default => 0 };

    $self->insert({
      name               => $name,
      zipcode            => $zipcode,
      address            => $address,
      explain            => $explain,
      x                  => $x,
      y                  => $y,
      area               => $area,
      is_locked          => $is_locked,
      is_evacuation_area => $is_evacuation_area,
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

