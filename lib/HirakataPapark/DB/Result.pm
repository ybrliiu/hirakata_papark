package HirakataPapark::DB::Result {

  use Mouse;
  use HirakataPapark;
  extends qw( Aniki::Result::Collection );

  use Option;

  sub first_with_option {
    my $self = shift;
    Option->new( $self->first );
  }

  sub last_with_option {
    my $self = shift;
    Option->new( $self->last );
  }

}

1;

