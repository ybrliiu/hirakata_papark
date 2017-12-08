use HirakataPapark 'test';
use Path::Tiny;
use HirakataPapark::Web::Plugin::AssetPack::Pipe::BundleJS;

my $pipe;
lives_ok { $pipe = HirakataPapark::Web::Plugin::AssetPack::Pipe::BundleJS->new };
lives_ok { $pipe->does_need_update };
diag path( $pipe->history_file_path )->slurp;

done_testing;

