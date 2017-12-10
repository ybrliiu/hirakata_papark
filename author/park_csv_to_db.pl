# 修正したSCVデータの公園情報及び遊具情報をDBに格納する

use lib './lib', './local/lib/perl5',
use HirakataPapark;
use Data::Dumper;
use Try::Tiny;
use Text::CSV_XS;
use List::Util qw( sum );
use HirakataPapark::Model::MultilingualDelegator::Parks::Parks;
use HirakataPapark::Model::MultilingualDelegator::Parks::Equipments;
use HirakataPapark::Model::MultilingualDelegator::Parks::Plants;
use HirakataPapark::Model::MultilingualDelegator::Parks::SurroundingFacilities;

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

my @PARK_FIELDS = qw( id name address y x area is_nice_scenery is_evacuation_area );
my @parks = map {
  my $park = $_;
  my %new_park;
  @new_park{@PARK_FIELDS} = map { $park->{$_} } @PARK_FIELDS;
  \%new_park;
} @$park_data_list_orig;

my @EPARK_FIELDS = qw( id name address );
my @eparks = map {
  my $park = $_;
  my %new_park;
  @new_park{@EPARK_FIELDS} = map { $park->{$_} } @EPARK_FIELDS;
  $new_park{name}    = join ' ', map { ucfirst $_ } split / /, $park->{english_name};
  $new_park{address} = join ', ', map { ucfirst $_ } split /, /, $park->{english_address};
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

my $model = HirakataPapark::Model::MultilingualDelegator::Parks::Parks->new;
my $txn = $model->model('ja')->txn_scope;
$model->model('ja')->add_rows(\@parks);
$model->model('en')->add_rows(\@eparks);

my $equipments_model = HirakataPapark::Model::MultilingualDelegator::Parks::Equipments->new;
my $facilities_model = HirakataPapark::Model::MultilingualDelegator::Parks::SurroundingFacilities->new;
my $plants_model     = HirakataPapark::Model::MultilingualDelegator::Parks::Plants->new;
for my $info (@parks_equipment) {
  my $park_id = $info->{id};
  my @equipments = map { $info->{$_} ? $_ : () } grep { $_ ne 'id' } keys %$info;
  say "id => $park_id";
  for my $equipment_name (@equipments) {
    if ( grep { $equipment_name eq $_ } @FACILITIES ) {
      $facilities_model->model('ja')->add_row({
        park_id => $park_id,
        name    => $equipment_name,
      });
      my $fc = $facilities_model->model('ja')->get_row_by_park_id_and_name($park_id, $equipment_name)->get;
      $facilities_model->model('en')->add_row({
        id      => $fc->id,
        park_id => $park_id,
        name    => $english_dict->{$equipment_name},
      });
    }
    elsif ( grep { $equipment_name eq $_ } @PLANTS ) {
      $plants_model->model('ja')->add_row({
        park_id  => $park_id,
        name     => $equipment_name,
        category => '桜',
        num      => $info->{$equipment_name},
      });
      my $plants = $plants_model->model('ja')->get_row_by_park_id_and_name($park_id, $equipment_name)->get;
      $plants_model->model('en')->add_row({
        id       => $plants->id,
        park_id  => $park_id,
        name     => $english_dict->{$equipment_name},
        category => $english_dict->{'桜'},
      });
    }
    elsif ( grep { $equipment_name eq $_ } @EQUIPMENTS ) {
      $equipments_model->model('ja')->add_row({
        park_id => $park_id,
        name    => $equipment_name,
        num     => $info->{$equipment_name},
      });
      my $e = $equipments_model->model('ja')->get_row_by_park_id_and_name($park_id, $equipment_name)->get;
      $equipments_model->model('en')->add_row({
        id      => $e->id,
        park_id => $park_id,
        name    => $english_dict->{$equipment_name},
      });
    }
  }
  my @blossoms = split /,/, $info->{'桜_その他_品種'};
  for my $blossom (@blossoms) {
    my $param = +{
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
    $plants_model->model('ja')->add_row($param);
    my $plants = $plants_model->model('ja')->get_row_by_park_id_and_name($park_id, $param->{name})->get;
    my $eparam = {
      id       => $plants->id,
      park_id  => $park_id,
      name     => ( $english_dict->{ $param->{name} } // die $param->{name} ),
      category => $english_dict->{ $param->{category} },
      comment  => $param->{comment} ? $english_dict->{ $param->{comment} } : '',
    };
    die $param->{comment} unless defined $eparam->{comment};
    $plants_model->model('en')->add_row($eparam);
  }
}

$txn->commit;

