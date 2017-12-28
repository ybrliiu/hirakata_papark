package HirakataPapark::Model::Parks::ImagesResult {

  use Mouse;
  use HirakataPapark;
  use Option;

  extends qw( HirakataPapark::Model::Result );

  sub to_hash_for_vue_images($self) {
    [ map { $_->to_hash_for_vue_images } $self->contents->@* ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

