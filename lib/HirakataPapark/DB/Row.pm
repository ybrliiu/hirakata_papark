package HirakataPapark::DB::Row {

  use Mouse;
  use HirakataPapark;
  extends qw( Aniki::Row );

  sub for_json {
    my $self = shift;
    $self->row_data;
  }

}

1;
