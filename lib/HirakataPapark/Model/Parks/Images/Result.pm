package HirakataPapark::Model::Parks::Images::Result {

  use Mouse;
  use HirakataPapark;
  use Option;

  extends qw( HirakataPapark::Model::Result );

  has 'static_path' => (
    is      => 'rw',
    isa     => 'Str',
    default => '.',
  );

  sub to_hash_for_vue_images($self) {
    my @hash_list = map {
      my $hash = $_->to_hash_for_vue_images;
      $hash->{imageUrl} = $self->static_path . "/$hash->{imageUrl}";
      $hash;
    } $self->contents->@*;
    \@hash_list;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

