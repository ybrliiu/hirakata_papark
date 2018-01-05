package Option::Option {

  use v5.14;
  use warnings;
  use Carp;
  
  sub new;

  sub exists;

  sub fold;

  sub foreach :method {
    my ($self, $code) = @_;
    Carp::croak 'Too few arguments (required: $code)' if @_ < 2;
    $self->yield($code);
    ();
  }

  sub flatten;

  sub flat_map {
    my ($self, $code) = @_;
    Carp::croak 'Too few arguments (required: $code)' if @_ < 2;
    $self->map($code)->flatten;
  }

  sub get;

  sub get_or_else;

  sub is_defined;

  sub is_empty { !shift->is_defined }

  sub map :method;

  sub match;

  sub to_left;

  sub to_list;

  sub to_right;

  sub yield;

}

1;

__END__

=encoding utf8

=head1 NAME
  
  Option - Option base class like Scala.Option.

=cut

