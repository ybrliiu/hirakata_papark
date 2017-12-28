package HirakataPapark::DB::Row::ParkImage {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::DB::Row';

  sub filename($self) {
    $self->filename_without_extension . '.' . $self->filename_extension;
  }

  sub to_hash_for_vue_images($self) {
    {
      caption  => $self->title,
      imageUrl => $self->filename,
    };
  }

  __PACKAGE__->meta->make_immutable;

}

1;

