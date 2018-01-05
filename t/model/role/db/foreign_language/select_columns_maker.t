use Test::HirakataPapark;
use Test::HirakataPapark::Container;
use HirakataPapark::Model::Role::DB::ForeignLanguage::SelectColumnsMaker;

my $c  = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;

subtest default_case => sub {
  my $maker;
  lives_ok {
    $maker = HirakataPapark::Model::Role::DB::ForeignLanguage::SelectColumnsMaker->new(
      schema               => $db->schema,
      table_name           => 'english_park',
      orig_lang_table_name => 'park',
    );
  };
  is_deeply $maker->select_columns, ['english_park.address', 'park.area', 'english_park.explain', 'english_park.id', 'park.is_evacuation_area', 'park.is_locked', 'english_park.name', 'park.x', 'park.y', 'park.zipcode'];
  is_deeply $maker->join_condition, { 'park.id' => 'english_park.id' };
};

# これいまは別にいらん機能かも
subtest specify_not_need_columns => sub {
  my $maker;
  lives_ok {
    $maker = HirakataPapark::Model::Role::DB::ForeignLanguage::SelectColumnsMaker->new(
      schema               => $db->schema,
      table_name           => 'english_park',
      orig_lang_table_name => 'park',
      not_need_columns     => ['name'],
    );
  };
  is_deeply $maker->select_columns, ['english_park.address', 'park.area', 'english_park.explain', 'english_park.id', 'park.is_evacuation_area', 'park.is_locked', 'park.x', 'park.y', 'park.zipcode'];
};

done_testing;

