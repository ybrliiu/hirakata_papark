use Test::HirakataPapark;
use Test::HirakataPapark::Container;
use aliased 'HirakataPapark::Model::Multilingual::Parks' => 'MultilingualParksModel';

my $c = Test::HirakataPapark::Container->new;
my $db = $c->fetch('DB/db')->get;
my $park = $c->fetch('TestData/Park/park')->get;
my $epark = $c->fetch('TestData/Park/english_park')->get;

my $model;
lives_ok { $model = MultilingualParksModel->new(db => $db) };
my $row;
lives_ok { $row = $model->get_multilingual_row_by_park_id('ja', $park->id) };
is $row->name, $park->name;
is $row->lang_records->en->name, $epark->name;

done_testing;
