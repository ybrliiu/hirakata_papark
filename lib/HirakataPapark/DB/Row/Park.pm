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
    if ($self->area >= 600) {
      '大';
    } elsif ($self->area >= 100) {
      '中';
    } else {
      '小';
    }
  }

  sub plants_categories {
    my $self = shift;
    [
      map { $_->category } 
      $self->handler->select(
        'park_plants',
        {park_id => $self->id},
        {prefix => 'SELECT DISTINCT ', columns => ['category'] },
      )->all
    ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

