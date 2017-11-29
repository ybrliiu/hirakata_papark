package HirakataPapark::DB::Row::EnglishPark {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::DB::Row';

  has 'name' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub ($self) { $self->get_column('english_name') },
  );

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

