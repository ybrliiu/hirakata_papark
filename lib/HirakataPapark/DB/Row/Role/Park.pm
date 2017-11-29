package HirakataPapark::DB::Row::Role::Park {

  use Mouse::Role;
  use HirakataPapark;

  use constant {
    WIDE   => 600,
    MIDDLE => 100,
  };

  requires qw( size );

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

