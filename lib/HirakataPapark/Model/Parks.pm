package HirakataPapark::Model::Parks {

  use Mouse;
  use HirakataPapark;

  use Option;
  use Smart::Args qw( args args_pos );
  
  use constant TABLE => 'park';

  with 'HirakataPapark::Model::Role::DB';

  sub add_row {
    args my $self, my $name => 'Str', my $addres => 'Str',
      my $x_coordinate => 'Num', my $y_coordinate => 'Num', my $area => 'Num';
    $self->insert({
      name         => $name,
      addres       => $addres,
      x_coordinate => $x_coordinate,
      y_coordinate => $y_coordinate,
      area         => $area,
    });
  }

  sub add_rows {
    args_pos my $self, my $hash_list => 'ArrayRef[HashRef]';
    $self->insert_multi($hash_list);
  }

  sub get_row_by_id {
    args_pos my $self, my $id => 'Int';
    Option->new( $self->select({id => $id})->first );
  }

  sub get_row_by_name {
    args_pos my $self, my $name => 'Str';
    Option->new( $self->select({name => $name})->first );
  }

}

1;

