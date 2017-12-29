package HirakataPapark::Model::Parks::ImagesResult {

  use Mouse;
  use HirakataPapark;
  use Option;

  extends qw( HirakataPapark::Model::Result );

  has 'save_dir_root' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  has 'static_url_root' => (
    is      => 'rw',
    isa     => 'Str',
    default => sub ($self) { $self->save_dir_root },
  );

  sub to_hash_for_vue_images($self) {
    my @hash_list = map {
      my $hash = $_->to_hash_for_vue_images;
      $hash->{imageUrl} = $self->static_url_root . "/$hash->{imageUrl}";
      $hash;
    } $self->contents->@*;
    \@hash_list;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

