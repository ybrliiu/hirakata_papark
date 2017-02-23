package HirakataPapark::DB::Row::ParkComment {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::DB::Row';

  use HirakataPapark::Util;
  use Time::Piece;

  sub datetime {
    my $self = shift;
    my $t = localtime $self->time;
    HirakataPapark::Util::datetime($t);
  }

  __PACKAGE__->meta->make_immutable;

}

1;

