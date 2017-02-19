package HirakataPapark::DB::Row::Park {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::DB::Row';

  sub to_json_for_marker {
    my $self = shift;
    qq!{ "id": @{[ $self->id ]}, "name": "@{[ $self->name ]}", "x": @{[ $self->x ]}, "y": @{[ $self->y ]} }!;
  }

  sub size {
    my $self = shift;
    if ($self->area >= 0.6) {
      '大';
    } elsif ($self->area >= 0.1) {
      '中';
    } else {
      '小';
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

