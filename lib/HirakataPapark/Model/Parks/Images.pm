package HirakataPapark::Model::Parks::Images {

  use Mouse;
  use HirakataPapark;
  use Path::Tiny qw( path );
  use Mojo::Util qw( hmac_sha1_sum );
  use Smart::Args qw( args );
  use HirakataPapark::Model::Parks::Images::Result;
  use HirakataPapark::Model::Parks::Images::SaveDirPath;

  # alias
  use constant SaveDirPath => 'HirakataPapark::Model::Parks::Images::SaveDirPath';

  use constant TABLE => 'park_image';

  has 'save_dir_root' => (
    is      => 'ro',
    isa     => 'Str',
    default => SaveDirPath->DEFAULT_SAVE_DIR_ROOT,
  );

  with 'HirakataPapark::Model::Role::DB';

  around create_result => sub ($orig, $self, $contents) {
    HirakataPapark::Model::Parks::Images::Result->new(contents => $contents);
  };

  sub add_row {
    args my $self, my $image_file => 'HirakataPapark::Class::Upload',
      my $park_id                => 'Int',
      my $posted_user_seacret_id => 'Int',
      my $title                  => 'Str';

    my $filename_without_extension = hmac_sha1_sum $image_file->slurp;
    my $save_dir = path SaveDirPath->save_dir_path($self->save_dir_root, $park_id);
    $save_dir->mkpath unless $save_dir->exists;
    my $filename = $filename_without_extension . '.' . $image_file->filename_extension;
    my $file_path = path "${save_dir}/${filename}";
    $image_file->move_to( $file_path->absolute );
    $file_path->chmod(0664);

    $self->insert({
      park_id                    => $park_id,
      posted_user_seacret_id     => $posted_user_seacret_id,
      title                      => $title,
      filename_without_extension => $filename_without_extension,
      filename_extension         => $image_file->filename_extension,
      posted_time                => time,
    });
  }

  sub delete_row($self, $park_id, $filename_without_extension) {
    my $row = $self->get_row($park_id, $filename_without_extension)->get;
    $self->delete({
      park_id                    => $park_id,
      filename_without_extension => $filename_without_extension
    });
    my $filename = $filename_without_extension . '.' . $row->filename_extension;
    path("@{[ $self->save_dir_root ]}/${park_id}/${filename}")->remove;
  }

  sub delete_rows_by_park_id($self, $park_id) {
    my $rows = $self->get_rows_by_park_id($park_id);
    $self->delete({ park_id => $park_id });
    for my $row (@$rows) {
      my $filename = $row->filename_without_extension . '.' . $row->filename_extension;
      path("@{[ $self->save_dir_root ]}/${park_id}/${filename}")->remove;
    }
  }

  sub get_row($self, $park_id, $filename_without_extension) {
    $self->select({
      park_id                    => $park_id,
      filename_without_extension => $filename_without_extension,
    })->first_with_option;
  }

  sub get_rows_by_park_id($self, $park_id, $num = 10) {
    $self->create_result([
      $self->select(
        { park_id => $park_id },
        { limit => $num, order_by => {filename_without_extension => 'DESC'} },
      )->all
    ]);
  }
  
  __PACKAGE__->meta->make_immutable;

}

1;

