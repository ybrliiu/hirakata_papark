use v5.24;
use warnings;
use utf8;
use Encode;
use lib './lib';

use Spreadsheet::ParseXLSX;
use HirakataPapark::Model::Parks;

my @COLUMNS = qw( id トイレ nothing ブランコ すべり台 鉄棒 ジャングルジム 砂場 シーソー );

my $parser = Spreadsheet::ParseXLSX->new;
my $workbook = $parser->parse('公園データ設備.xlsx');
my $worksheet = ($workbook->worksheets)[0];
my ($row_min, $row_max) = $worksheet->row_range;
my ($col_min, $col_max) = $worksheet->col_range;

my @parks = map {
  my $row = $_;
  my @row_values = map {
    my $col  = $_;
    my $cell = $worksheet->get_cell($row, $col);
    if (defined $cell) {
      $cell->value;
    } else {
      ();
    }
  } $col_min .. $col_max;
  my %hash;
  @hash{@COLUMNS} = @row_values;
  delete $hash{$_} for qw( nothing );
  \%hash;
} $row_min + 1 .. $row_max;

use Data::Dumper;
say Dumper \@parks;

use HirakataPapark::Model::Parks::Equipments;
my $model = HirakataPapark::Model::Parks::Equipments->new;
for my $info (@parks) {
  my $park_id = $info->{id};
  my @equipments = map { $info->{$_} eq '有' ? $_ : () } keys %$info;
  for my $equipment_name (@equipments) {
    $model->add_row({
      park_id => $park_id,
      name    => $equipment_name,
    });
  }
}

