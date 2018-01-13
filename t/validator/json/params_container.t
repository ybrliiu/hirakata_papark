use Test::HirakataPapark;
use JSON::XS qw( decode_json );
use aliased 'HirakataPapark::Validator::JSON::ParamsContainer';

my $container;
my $json = decode_json '{"id": 0, "sub": {"id": 1}}';
lives_ok { $container = ParamsContainer->new(json => $json) };

done_testing;
