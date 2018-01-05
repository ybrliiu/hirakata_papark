use Test::HirakataPapark;
use Path::Tiny;
use JSON::XS;
use HirakataPapark::Service::Build::TranslateLangDictToJSONAndSave::JobRunner;

my $json_dir_root = './t/for_test/lang-dicts/';
my $work_dir = path($json_dir_root);
$work_dir->mkpath;

my $runner;
lives_ok {
  $runner = HirakataPapark::Service::Build::TranslateLangDictToJSONAndSave::JobRunner->new(
    json_dir_root => $json_dir_root,
  );
};
lives_ok { $runner->run };

my $iter = path("$work_dir")->iterator({recurse => 1});
my $file_num = 0;
while ( my $path = $iter->() ) {
  if ($path->is_file) {
    if ($path =~ /(??{ $runner->history_manager->DEFAULT_RECORD_FILE_NAME })/) {
      my $history;
      lives_ok { $history = do $path };
      is keys %$history, @{ $runner->lang_dict_names } * 2;
    }
    else {
      lives_ok { decode_json $path->slurp };
    }
    $file_num++;
  }
}
is @{ $runner->lang_dict_names } * 2 + 1, $file_num;

$work_dir->remove_tree;
rmdir $work_dir;

done_testing;
