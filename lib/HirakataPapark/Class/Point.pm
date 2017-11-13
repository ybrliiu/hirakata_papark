package HirakataPapark::Class::Point {

  use Mouse;
  use HirakataPapark;

  has [qw/ x y /] => ( is => 'ro', isa => 'Num', required => 1 );

  with 'HirakataPapark::Role::Point';

  __PACKAGE__->meta->make_immutable;

}

1;

