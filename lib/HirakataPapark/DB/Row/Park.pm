package HirakataPapark::DB::Row::Park {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::DB::Row';

  sub to_json_for_marker {
    my $self = shift;
    qq!{ "id": @{[ $self->id ]}, "name": "@{[ $self->name ]}", "x": @{[ $self->x ]}, "y": @{[ $self->y ]} }!;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

