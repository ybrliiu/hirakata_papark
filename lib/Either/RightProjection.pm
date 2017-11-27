package Either::RightProjection {

  use v5.14;
  use warnings;
  use parent 'Either::Projection';

  use Option::NoSuchElementException;

  # override
  sub new {
    my ($class, $either) = @_;
    Carp::croak 'type mismatch. required Either' unless $either->isa('Either::Either');
    bless {either => $either}, $class;
  }

  # override
  sub _is_available {
    my $self = shift;
    $self->{either}->is_right;
  }

  # override
  sub flat_map {
    my ($self, $code) = @_;
    $self->map($code)->join_right;
  }

}

1;

