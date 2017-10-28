package HirakataPapark::DB::Row::Park {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::DB::Row';

  use constant {
    WIDE   => 600,
    MIDDLE => 100,
  };

  sub to_json_for_marker {
    my $self = shift;
    qq!{ "id": @{[ $self->id ]}, "name": "@{[ $self->name ]}", "x": @{[ $self->x ]}, "y": @{[ $self->y ]} }!;
  }

  sub to_english_json_for_marker {
    my $self = shift;
    qq!{ "id": @{[ $self->id ]}, "name": "@{[ $self->english_name ]}", "x": @{[ $self->x ]}, "y": @{[ $self->y ]} }!;
  }

  sub size {
    my $self = shift;
    if ($self->area >= WIDE) {
      '大';
    } elsif ($self->area >= MIDDLE) {
      '中';
    } else {
      '小';
    }
  }

  sub english_size {
    my $self = shift;
    if ($self->area >= WIDE) {
      'Wide';
    } elsif ($self->area >= MIDDLE) {
      'Middle';
    } else {
      'Narrow';
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

  sub plants_english_categories {
    my $self = shift;
    [
      map { $_->english_category } 
      $self->handler->select(
        'park_plants',
        {park_id => $self->id},
        {prefix => 'SELECT DISTINCT ', columns => ['english_category'] },
      )->all
    ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

