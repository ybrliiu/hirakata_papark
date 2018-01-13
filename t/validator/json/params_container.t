use Test::HirakataPapark;
use JSON::XS qw( decode_json );
use aliased 'HirakataPapark::Validator::JSON::ParamsContainer';

my $container;
my $json = decode_json '{"id": 0, "sub": {"id": 1}}';
lives_ok { $container = ParamsContainer->new(json => $json) };
my $sub_params;
lives_ok { $sub_params = $container->get_sub_params('sub')->get };
is $sub_params->param('id')->get, 1;

done_testing;
