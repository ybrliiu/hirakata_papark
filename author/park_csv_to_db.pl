# 修正したSCVデータの公園情報及び遊具情報をDBに格納する

use lib './lib';
use HirakataPapark;
use Data::Dumper;
use Try::Tiny;
use Text::CSV_XS;
use List::Util qw( sum );
use HirakataPapark::Model::Parks;
use HirakataPapark::Model::Parks::Equipments;
use HirakataPapark::Model::Parks::Plants;
use HirakataPapark::Model::Parks::SurroundingFacilities;

my @FACILITIES     = qw( 有料駐車場 無料駐車場 );
my @PLANTS         = qw( ソメイヨシノ オオシマザクラ カンヒザクラ シダレザクラ カワヅザクラ ヤマザクラ );
my @ANOTHER_PLANTS = qw( 桜_その他 桜_合計 桜_その他_品種 );
my @COLUMNS = (
  qw(
    id name y x address area area_ha is_evacuation_area
    ブランコ_2 ブランコ_3 ブランコ_4 すべり台
    鉄棒_1 鉄棒_2 鉄棒_3 鉄棒_4 鉄棒_5
    シーソー ジャングルジム 複合遊具 砂場 ラダー 健康遊具 プレイスカルプチャー(遊戯彫刻)
    トイレ 水飲場 ベンチ 四阿・シェルター
  ),
  @FACILITIES,
  @PLANTS,
  @ANOTHER_PLANTS,
  qw( is_nice_scenery english_name english_address ),
);

my $english_dict = {
  '有料駐車場'                     => 'Toll parking',
  '無料駐車場'                     => 'Free parking',
  '桜'                             => 'Cherry Blossoms',
  'ソメイヨシノ'                   => 'Yoshino cherry',
  'オオシマザクラ'                 => 'Oshima cherry',
  'カンヒザクラ'                   => 'Kanhizakura',
  'シダレザクラ'                   => 'Shidarezakura',
  'カワヅザクラ'                   => 'Kawaduzakura',
  'ヤマザクラ'                     => 'Yamazakura',
  'サトザクラ'                     => 'Satozakura',
  'ヤエザクラ'                     => 'Yaezakura',
  'アマノガワ'                     => 'Amanogawa',
  'ヤエアケボノ'                   => 'Yaeakebono',
  'ハクサンオオデマリ'             => 'Hakusamoodemari',
  'コウヨウザクラ'                 => 'Kouyouzakura',
  'オオヤマザクラ'                 => 'Ooyamazakura',
  'ヤエベニシダレ'                 => 'Yaebenishidare',
  'ブランコ'                       => 'Swing',
  'すべり台'                       => 'Slide',
  '鉄棒'                           => 'Horizontal bar',
  'シーソー'                       => 'Seesaw',
  'ジャングルジム'                 => 'Jungle gym',
  '複合遊具'                       => 'Combined play equipment',
  '砂場'                           => 'Sandbox',
  'ラダー'                         => 'Ladder',
  '健康遊具'                       => 'Healthy play equipment',
  'プレイスカルプチャー(遊戯彫刻)' => 'Play sculpture',
  'トイレ'                         => 'Toilet',
  '水飲場'                         => 'Drinking fountains',
  'ベンチ'                         => 'Bench',
  '四阿・シェルター'               => 'Chickee',
  'エドヒガン'                     => 'Edohiganzakura',
  '古木(淡墨桜)。'                 => 'Old tree(Usuzumizakura).',
  '個数不明。'                     => 'The number is not recorded.',
  '古木(淡墨桜)。個数不明。'       => 'Old tree(Usuzumizakura). The number is not recorded.',
};

sub get_csv_data {
  my $file_name = shift;
  open my $fh, '<', $file_name;
  my $parser = Text::CSV_XS->new({binary => 1});
  my @park_data;
  while ( my $columns = $parser->getline($fh) ) {
    my %park;
    @park{@COLUMNS} = @$columns;
    next if $park{id} eq 'NO';
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

my $park_data_list_orig = get_csv_data('./data/manually_fix_add_english_park_data.csv');
shift @$park_data_list_orig;

my @PARK_FIELDS = qw( id name address y x area is_nice_scenery is_evacuation_area english_name english_address );
my @parks = map {
  my $park = $_;
  my %new_park;
  @new_park{@PARK_FIELDS} = map { $park->{$_} } @PARK_FIELDS;
  $new_park{english_name}    = join ' ', map { ucfirst $_ } split / /, $new_park{english_name};
  $new_park{english_address} = join ', ', map { ucfirst $_ } split /, /, $new_park{english_address};
  \%new_park;
} @$park_data_list_orig;

my @EQUIPMENTS = qw(
  id
  ブランコ すべり台 鉄棒 シーソー ジャングルジム
  複合遊具 砂場 ラダー 健康遊具 プレイスカルプチャー(遊戯彫刻)
  トイレ 水飲場 ベンチ 四阿・シェルター
);
my @EQUIPMENT_FIELD = (
  @EQUIPMENTS,
  @FACILITIES,
  @PLANTS,
  @ANOTHER_PLANTS,
);
my @parks_equipment = map {
  my $park = $_;
  my %new_park;
  @new_park{@EQUIPMENT_FIELD} = map { $park->{$_} } @EQUIPMENT_FIELD;
  \%new_park;
} @$park_data_list_orig;

my $model = HirakataPapark::Model::Parks->new;
my $txn = $model->txn_scope;
$model->add_rows(\@parks);

my $equipments_model = HirakataPapark::Model::Parks::Equipments->new;
my $facilities_model = HirakataPapark::Model::Parks::SurroundingFacilities->new;
my $plants_model     = HirakataPapark::Model::Parks::Plants->new;
for my $info (@parks_equipment) {
  my $park_id = $info->{id};
  my @equipments = map { $info->{$_} ? $_ : () } grep { $_ ne 'id' } keys %$info;
  say "id => $park_id";
  for my $equipment_name (@equipments) {
    if ( grep { $equipment_name eq $_ } @FACILITIES ) {
      $facilities_model->add_row({
        park_id      => $park_id,
        name         => $equipment_name,
        english_name => $english_dict->{$equipment_name},
      });
    }
    elsif ( grep { $equipment_name eq $_ } @PLANTS ) {
      $plants_model->add_row({
        park_id          => $park_id,
        name             => $equipment_name,
        english_name     => $english_dict->{$equipment_name},
        category         => '桜',
        english_category => $english_dict->{'桜'},
        num              => $info->{$equipment_name},
      });
    }
    elsif ( grep { $equipment_name eq $_ } @EQUIPMENTS ) {
      $equipments_model->add_row({
        park_id      => $park_id,
        name         => $equipment_name,
        english_name => $english_dict->{$equipment_name},
        num          => $info->{$equipment_name},
      });
    }
  }
  my @blossoms = split /,/, $info->{'桜_その他_品種'};
  for my $blossom (@blossoms) {
    my $param = {
      park_id  => $park_id,
      category => '桜',
      name     => ($blossom eq '淡墨桜' ? 'エドヒガン' : $blossom),
      num      => (@blossoms == 1 ? $info->{'桜_その他'} : 0),
      comment  => do {
        my $comment = '';
        if ($blossom eq '淡墨桜') {
          $comment .= '古木(淡墨桜)。';
        }
        unless (@blossoms == 1) {
          $comment .= '個数不明。';
        }
        $comment;
      },
    };
    $param->{english_name}     = $english_dict->{$param->{name}} // die $param->{name};
    $param->{english_category} = $english_dict->{$param->{category}};
    $param->{english_comment}  = $param->{comment} ? $english_dict->{$param->{comment}} : '';
    die $param->{comment} unless defined $param->{english_comment};
    $plants_model->add_row($param);
  }
}

$txn->commit;

