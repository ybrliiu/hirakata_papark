# 2017年12月に公開された公園データの郵便番号データを補完するプログラム
# GoogleMap APIで

use lib './lib', './author';
use HirakataPapark;
use CSVEditer;
use LWP::UserAgent;
use Data::Dumper;
use JSON::XS qw( decode_json );

my @COLUMNS = qw(
  id name name_kana address area area_ha y x is_evacuation_area
  ブランコ_2 ブランコ_3 ブランコ_4 すべり台
  鉄棒_1 鉄棒_2 鉄棒_3 鉄棒_4 鉄棒_5
  シーソー ジャングルジム 鋼製複合遊具 砂場 ラダー 健康遊具 プレイスカルプチャー(遊戯彫刻)
  便所 水飲場 ベンチ 四阿(シェルター) 有料駐車場 無料駐車場 
  ソメイヨシノ オオシマザクラ カンヒザクラ シダレザクラ カワズザクラ ヤマザクラ 桜_その他 桜_合計 桜_その他_品種
  is_nice_scenery
  english_name
  english_address
  zipcode
  address_kana
);

my $editer = CSVEditer->new({
  columns        => \@COLUMNS,
  get_file_name  => 'data/parks_strict_fixed_2017_1212.csv',
  save_file_name => 'data/parks_add_zipcode_2017_1212.csv',
});

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->default_header('Accept-Language' => "ja,en-US;");
my $API_KEY = 'AIzaSyAnC_0UZUQLeEHr2fjj1CZ1txmI5vxE-ZQ';

sub get_zipcode($y, $x) {
  my $res = $ua->get('https://maps.googleapis.com/maps/api/geocode/json?latlng=' . $y . ',' . $x . '&key=' . $API_KEY);
  my $json = decode_json( $res->is_success ? $res->content : '{}' );
  $json->{results}[0]{address_components}[-1]{long_name};
}

my $parks = $editer->get_csv_data();
for my $park (@$parks) {
  next if $park->{id} eq 'id';
  $park->{zipcode} = get_zipcode($park->{y}, $park->{x});
  # 郵便番号がわからない場合国名が帰るようだ
  warn $park->{zipcode};
}
$editer->save_csv_data($parks);

sub verify($parks) {
  for my $park (@$parks) {
    next if $park->{id} eq 'id';
    warn $park->{name} if $park->{zipcode} eq '';
  }
}

