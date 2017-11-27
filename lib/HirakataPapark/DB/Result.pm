package HirakataPapark::DB::Result {

  use Mouse;
  use HirakataPapark;
  extends qw( Aniki::Result::Collection );

  use Option;

  sub first_with_option {
    my $self = shift;
    option $self->first;
  }

  sub last_with_option {
    my $self = shift;
    option $self->last;
  }

}

1;

