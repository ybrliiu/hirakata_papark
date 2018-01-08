use HirakataPapark;

use SQL::Maker::Select;

my $select = SQL::Maker::Select->new;
$select->add_from('park_edit_history');
$select->add_select('id');
$select->add_where(editer_seacret_id => '1234');

my $stmt = SQL::Maker::Select->new;
$stmt->add_from('park_english_history');
$stmt->add_select('*');
$stmt->add_where(history_id => {IN => \[$select->as_sql, $select->bind]});
say $stmt->as_sql;
say $stmt->bind;

