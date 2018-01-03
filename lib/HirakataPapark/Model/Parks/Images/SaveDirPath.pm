package HirakataPapark::Model::Parks::Images::SaveDirPath {

  use HirakataPapark;
  use constant DEFAULT_SAVE_DIR_ROOT => 'public/images/parks';

  sub save_dir_path($class, $save_dir_root, $park_id) {
    $save_dir_root . '/' . $park_id;
  }

}

1;
