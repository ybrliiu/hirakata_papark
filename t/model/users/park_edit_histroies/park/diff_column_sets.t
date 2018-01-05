use Test::HirakataPapark;
use HirakataPapark::Model::Users::ParkEditHistories::Park::DiffColumnSets;

# alias
use constant Sets => 'HirakataPapark::Model::Users::ParkEditHistories::Park::DiffColumnSets';

lives_ok {
  my $sets = Sets->new(
    park_name    => 'A公園',
    park_address => 'A市B町',
    park_explain => 'hogehoge...',
  );
};

done_testing;
