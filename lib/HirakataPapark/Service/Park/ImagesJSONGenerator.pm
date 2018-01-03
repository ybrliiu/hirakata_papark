package HirakataPapark::Service::Park::ImagesJSONGenerator {

  use Mouse;
  use HirakataPapark;
  use Encode qw( decode_utf8 );
  use JSON::XS qw( encode_json );
  use HirakataPapark::Model::Parks::Images::SaveDirPath;

  has 'images' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Parks::Images::Result',
    required => 1,
  );

  has 'static_path' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  has 'park_id' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  has 'images_path' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    builder => '_build_images_path',
  );

  sub _build_images_path($self) {
    my $save_dir_root = 
      HirakataPapark::Model::Parks::Images::SaveDirPath->DEFAULT_SAVE_DIR_ROOT;
    my @paths = split m!/!, $save_dir_root;
    # remove public
    shift @paths;
    unshift @paths, $self->static_path;
    push @paths, $self->park_id;
    join '/', @paths;
  }

  sub generate($self) {
    my $images = $self->images;
    $images->static_path($self->images_path);
    my $hash_list = do {
      my $hash_list = $images->to_hash_for_vue_images;
      @$hash_list == 0 ? [{imageUrl => '', caption => ''}] : $hash_list;
    };
    decode_utf8 encode_json $hash_list;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
