package HirakataPapark::DB::Result {

  use Mouse;
  use Option;
  use HirakataPapark;
  extends qw( Aniki::Result::Collection );

  sub first_with_option($self) {
    option $self->first;
  }

  sub last_with_option($self) {
    option $self->last;
  }

}

1;

