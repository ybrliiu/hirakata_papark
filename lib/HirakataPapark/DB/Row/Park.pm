package HirakataPapark::DB::Row::Park {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::DB::Row';

  with 'HirakataPapark::DB::Row::Role::Park';

  sub size {
    my $self = shift;
    if ($self->area >= $self->WIDE) {
      '大';
    } elsif ($self->area >= $self->MIDDLE) {
      '中';
    } else {
      '小';
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

