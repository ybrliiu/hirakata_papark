use v5.24;
use warnings;
use utf8;
use Encode;
use lib './lib';

use Spreadsheet::ParseXLSX;
use HirakataPapark::Model::Parks::Parks;

my @COLUMNS = qw( id type1 type2 name x y area address );

my $parser = Spreadsheet::ParseXLSX->new;
my $workbook = $parser->parse('./data/公園データ.xlsx');
my $worksheet = ($workbook->worksheets)[0];
my ($row_min, $row_max) = $worksheet->row_range;
my ($col_min, $col_max) = $worksheet->col_range;

my @parks = map {
  my $row = $_;
  my @row_values = map {
    my $col  = $_;
    my $cell = $worksheet->get_cell($row, $col);
    $cell->value;
  } $col_min .. $col_max;
  my %hash;
  @hash{@COLUMNS} = @row_values;
  delete $hash{$_}  for qw( type1 type2 );
  \%hash;
} $row_min + 1 .. $row_max;

use Data::Dumper;
say Dumper \@parks;

__END__

my $model = HirakataPapark::Model::Parks::Parks->new;
$model->add_rows(\@parks);

