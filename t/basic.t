use Mojo::Base -strict;
use HirakataPapark 'test';

use Test::Mojo;

my $t = Test::Mojo->new('HirakataPapark::Web');
$t->get_ok('/')->status_is(302);
$t->get_ok('/ja')->status_is(200);
$t->get_ok('/ja/current-location')->status_is(200);
$t->get_ok('/ja/about')->status_is(200);

$t->get_ok('/ja/park/1')->status_is(200);
$t->get_ok('/ja/park/plants/1')->status_is(200);
$t->get_ok('/ja/park/get-comments/1')->status_is(200);

$t->get_ok('/ja/searcher')->status_is(200);
for my $path (qw/ tag name plants address equipment surrounding-facility /) {
  $t->get_ok("/ja/searcher/$path")->status_is(200);
}

for my $path (qw/ register session /) {
  $t->get_ok("/ja/user/$path")->status_is(200);
}
$t->get_ok("/ja/user/twitter/register-modifiable")->status_is(200);

done_testing();
