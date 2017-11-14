package HirakataPapark::DB::Row::Park {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::DB::Row';

  with 'HirakataPapark::Role::Coord';

  sub x {
    my $self = shift;
    $self->get('x');
  }

  sub y {
    my $self = shift;
    $self->get('y');
  }

  sub to_json_for_marker {
    my $self = shift;
    qq!{ "id": @{[ $self->id ]}, "name": "@{[ $self->name ]}", "x": @{[ $self->x ]}, "y": @{[ $self->y ]} }!;
  }

  sub to_english_json_for_marker {
    my $self = shift;
    qq!{ "id": @{[ $self->id ]}, "name": "@{[ $self->english_name ]}", "x": @{[ $self->x ]}, "y": @{[ $self->y ]} }!;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

