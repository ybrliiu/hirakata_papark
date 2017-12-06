package HirakataPapark::DB::Row::EnglishPark {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::DB::Row';

  with 'HirakataPapark::DB::Row::Role::Park';

  sub size($self) {
    if ($self->area >= $self->WIDE) {
      'Wide';
    } elsif ($self->area >= $self->MIDDLE) {
      'Middle';
    } else {
      'Narrow';
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

