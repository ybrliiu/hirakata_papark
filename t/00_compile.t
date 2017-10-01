use HirakataPapark 'test';
use Path::Tiny;

my $itr = path('./lib')->iterator({recurse => 1});
while (my $file = $itr->()) {
  if ( $file->is_file ) {
    my $pm = $file =~ s!lib/|\.pm!!gr =~ s!/!::!gr;
    use_ok $pm;
  }
}

done_testing;
