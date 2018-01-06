use Test::HirakataPapark;
use HirakataPapark::Model::Users::ParkEditHistories::Park::DiffColumnSets;
use HirakataPapark::Model::Users::ParkEditHistories::Park::ForeignLangTableSets;

# alias
use constant {
  Sets =>
    'HirakataPapark::Model::Users::ParkEditHistories::Park::DiffColumnSets',
  ForeignLangTableSets =>
    'HirakataPapark::Model::Users::ParkEditHistories::Park::ForeignLangTableSets',
};

subtest has_empty => sub {
  my $sets;
  lives_ok {
    $sets = ForeignLangTableSets->new(ja => Sets->new(
      park_name    => 'A公園',
      park_address => 'ahlfhkassa',
      park_explain => 'sedl;dskals',
    ));
  };
  ok !$sets->has_all;
};

subtest has_empty2 => sub {
  my $sets;
  lives_ok {
    $sets = ForeignLangTableSets->new(
      ja => Sets->new(
        park_name    => 'A公園',
        park_address => 'ahlfhkassa',
        park_explain => 'sedl;dskals',
      ),
      en => Sets->new(park_name => 'A Park'),
    );
  };
  ok !$sets->has_all;
};

subtest has_all => sub {
  my $sets;
  lives_ok {
    $sets = ForeignLangTableSets->new(
      ja => Sets->new(
        park_name    => 'A公園',
        park_address => 'ahlfhkassa',
        park_explain => 'sedl;dskals',
      ),
      en => Sets->new(
        park_name    => 'A Park',
        park_address => 'ahlfhkassa',
        park_explain => 'sedl;dskals',
      ),
    );
  };
  ok $sets->has_all;
};

done_testing;
