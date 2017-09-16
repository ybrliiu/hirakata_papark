use Mojo::Base -strict;
use HirakataPapark 'test';

use Test::HirakataPapark::PostgreSQL;
my $PSQL = Test::HirakataPapark::PostgreSQL->new;

use Test::Mojo;

my $t = Test::Mojo->new('HirakataPapark::Web');
$t->get_ok('/')->status_is(200);

done_testing();
