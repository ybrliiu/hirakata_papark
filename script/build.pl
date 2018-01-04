# アプリ起動時に一緒に起動しておくべきなスクリプト
use strict;
use warnings;
use FindBin;
BEGIN { unshift @INC, map { "$FindBin::Bin/../$_" } qw( lib local/lib/perl5 ) }
use HirakataPapark;
use HirakataPapark::Service::Build::TranslateLangDictToJSONAndSave::JobRunner;

# generate assets/json/lang-dicts/*.json
my $jobrunner =
  HirakataPapark::Service::Build::TranslateLangDictToJSONAndSave::JobRunner->new;
$jobrunner->run;
