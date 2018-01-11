# 一気に書き換えるプログラム

use HirakataPapark;
use Path::Tiny;

for my $dir ('./t', './lib') {
  my $itr = path($dir)->iterator({recurse => 1});
  while (my $file = $itr->()) {
    if ( $file->is_file ) {
      my @lines = $file->lines;
      my @new_lines = map {
        $_ =~ s/with 'HirakataPapark::Service::Role::Validator';/with 'HirakataPapark::Validator::Validator';/gr;
      } @lines;
      $file->spew(@new_lines);
    }
  }
}
