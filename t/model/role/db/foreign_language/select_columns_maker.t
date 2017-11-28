use HirakataPapark 'test';
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
  is $maker->output_for_sql, 'english_park.address, park.area, english_park.english_name, english_park.explain, park.good_count, english_park.id, park.is_evacuation_area, park.is_nice_scenery, park.name, park.remarks_about_plants, park.x, park.y';
  diag $maker->output_relate_fields_for_sql, 'park.id = english_park.id';
};

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
  is $maker->output_for_sql, 'english_park.address, park.area, english_park.english_name, english_park.explain, park.good_count, english_park.id, park.is_evacuation_area, park.is_nice_scenery, park.remarks_about_plants, park.x, park.y';
};

done_testing;

