package HirakataPapark::Class::Upload {

  use Mouse;
  use HirakataPapark;

  has 'upload' => (
    is       => 'ro',
    isa      => 'Mojo::Upload',
    handles  => [qw( asset filename headers name move_to size slurp )],
    required => 1,
  );

  has 'filename_extension' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    builder => '_build_filename_extension',
  );

  has 'filename_without_extension' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    builder => '_build_filename_without_extension',
  );

  sub _build_filename_extension($self) {
    ($self->filename =~ /.*?\.(.*)/)[0]
  }

  sub _build_filename_without_extension($self) {
    ($self->filename =~ /(.*?)\..*/)[0]
  }

  __PACKAGE__->meta->make_immutable;

}

1;

