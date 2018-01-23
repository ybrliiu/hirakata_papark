use Test::HirakataPapark;
use Test::HirakataPapark::Container;
use aliased 'HirakataPapark::Model::Role::DB::TablesMeta::ForeignLang' => 'TablesMeta';

my $c  = Test::HirakataPapark::Container->new;
my $db = $c->get_sub_container('DB')->get_service('db')->get;

subtest default_case => sub {
  my $tables_meta;
  lives_ok {
    $tables_meta = TablesMeta->new(
      lang                    => 'en',
      schema                  => $db->schema,
      body_table_name         => 'park',
      foreign_lang_table_name => 'english_park',
    );
  };
  is_deeply $tables_meta->select_columns, [
    'park.id',
    'park.name',
    'park.zipcode',
    'park.address',
    'park.explain',
    'park.x',
    'park.y',
    'park.area',
    'park.is_evacuation_area',
    'park.is_locked',
    'english_park.name',
    'english_park.address',
    'english_park.explain',
  ];
  is_deeply $tables_meta->foreign_lang_table->join_condition, { 'english_park.id' => 'park.id' };
};

done_testing;

