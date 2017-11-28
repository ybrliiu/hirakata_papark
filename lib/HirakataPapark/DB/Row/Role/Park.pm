package HirakataPapark::DB::Row::Role::Park {

  use Mouse::Role;
  use HirakataPapark;

  with 'HirakataPapark::Role::Coord';

  sub x;
  has 'x' => (
    is      => 'ro',
    isa     => 'Num',
    lazy    => 1,
    default => sub ($self) { $self->get_column('x') },
  );

  sub y;
  has 'y' => (
    is      => 'ro',
    isa     => 'Num',
    lazy    => 1,
    default => sub ($self) { $self->get_column('y') },
  );

  sub to_json_for_marker {
    my $self = shift;
    qq!{ "id": @{[ $self->id ]}, "name": "@{[ $self->name ]}", "x": @{[ $self->x ]}, "y": @{[ $self->y ]} }!;
  }

}

1;

