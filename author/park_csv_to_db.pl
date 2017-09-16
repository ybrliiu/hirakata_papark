# 修正したSCVデータの公園情報及び遊具情報をDBに格納する

use lib './lib';
use HirakataPapark;
use Data::Dumper;
use Text::CSV_XS;
use List::Util qw( sum );
use HirakataPapark::Model::Parks;
use HirakataPapark::Model::Parks::Equipments;

my @COLUMNS = qw(
  id name y x address area area_ha is_evacuation_area
  ブランコ_2 ブランコ_3 ブランコ_4 すべり台
  鉄棒_1 鉄棒_2 鉄棒_3 鉄棒_4 鉄棒_5
  シーソー ジャングルジム 複合遊具 砂場 ラダー 健康遊具 プレイスカルプチャー(遊戯彫刻)
  トイレ 水飲場 ベンチ 四阿・シェルター 有料駐車場 無料駐車場 
  ソメイヨシノ オオシマザクラ カンヒザクラ シダレザクラ カワズザクラ ヤマザクラ 桜_その他 桜_合計 桜_その他_品種
  is_nice_scenery
);

sub get_csv_data {
  my $file_name = shift;
  open my $fh, '<', $file_name;
  my $parser = Text::CSV_XS->new({binary => 1});
  my @park_data;
  while ( my $columns = $parser->getline($fh) ) {
    my %park;
    @park{@COLUMNS} = @$columns;
    $park{id} -= 1;
    $park{area} =~ s/,//g;
    $park{area} += 0;
    $park{is_evacuation_area} = $park{is_evacuation_area} eq '○' ? 1 : 0;
    $park{is_nice_scenery}    = $park{is_nice_scenery} eq '○'    ? 1 : 0;
    no warnings 'numeric';
    $park{'ブランコ'}         = sum map { $park{"ブランコ_$_"} * $_ } 2 .. 4;
    $park{'鉄棒'}             = sum map { $park{"鉄棒_$_"}     * $_ } 1 .. 5;
    push @park_data, \%park;
  }
  $fh->close;
  \@park_data;
}

my $park_data_list_orig = get_csv_data('./data/manually_fix_park_data.csv');
shift @$park_data_list_orig;

my @PARK_FIELDS = qw( id name address y x area is_nice_scenery is_evacuation_area );
my @parks = map {
  my $park = $_;
  my %new_park;
  @new_park{@PARK_FIELDS} = map { $park->{$_} } @PARK_FIELDS;
  \%new_park;
} @$park_data_list_orig;

my @EQUIPMENT_FIELD = qw(
  id
  ブランコ すべり台 鉄棒 シーソー ジャングルジム
  複合遊具 砂場 ラダー 健康遊具 プレイスカルプチャー(遊戯彫刻)
  トイレ 水飲場 ベンチ 四阿・シェルター
);
my @parks_equipment = map {
  my $park = $_;
  my %new_park;
  @new_park{@EQUIPMENT_FIELD} = map { $park->{$_} } @EQUIPMENT_FIELD;
  \%new_park;
} @$park_data_list_orig;

my $model = HirakataPapark::Model::Parks->new;
$model->add_rows(\@parks);

my $model = HirakataPapark::Model::Parks::Equipments->new;
for my $info (@parks_equipment) {
  my $park_id = $info->{id};
  my @equipments = map { $info->{$_} ? $_ : () } grep { $_ ne 'id' } keys %$info;
  say "id => $park_id";
  for my $equipment_name (@equipments) {
    print Encode::encode_utf8("$equipment_name => $info->{$equipment_name},");
    $model->add_row({
      park_id => $park_id,
      name    => $equipment_name,
      num     => $info->{$equipment_name},
    });
  }
  print "\n";
}
