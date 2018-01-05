# 一気に書き換えるプログラム

use HirakataPapark;
use Path::Tiny;

__END__
my $itr = path('./t')->iterator({recurse => 1});
while (my $file = $itr->()) {
  if ( $file->is_file ) {
    my @lines = $file->lines;
    my @new_lines = map {
      $_ =~ s/use HirakataPapark 'test';/use Test::HirakataPapark;/gr;
    } @lines;
    $file->spew(@new_lines);
  }
}

