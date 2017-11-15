package HirakataPapark::Class::Coord {

  use Mouse;
  use HirakataPapark;

  has [qw/ x y /] => ( is => 'ro', isa => 'Num', required => 1 );

  with 'HirakataPapark::Role::Coord';

  __PACKAGE__->meta->make_immutable;

}

1;

