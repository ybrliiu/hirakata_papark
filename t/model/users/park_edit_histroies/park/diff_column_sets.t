use Test::HirakataPapark;
use HirakataPapark::Model::Users::ParkEditHistories::Park::DiffColumnSets;

# alias
use constant Sets => 'HirakataPapark::Model::Users::ParkEditHistories::Park::DiffColumnSets';

my $sets;
my $params = +{
  park_name    => 'A公園',
  park_address => 'A市B町',
  park_explain => 'hogehoge...',
};
lives_ok { $sets = Sets->new($params) };
is_deeply $sets->to_params, $params;

done_testing;
