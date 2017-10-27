# data/kouen_jyouhou.csv の公園の住所データを自動的に補完するプログラム
# google map API を利用
# https://developers.google.com/maps/documentation/geocoding/start?hl=ja#get-a-key

use lib './lib', './author';
use HirakataPapark;
use CSVEditer;
use LWP::UserAgent;
use JSON qw( decode_json );

my @COLUMNS = qw(
  id name y x address area area_ha is_evacuation_area
  ブランコ_2 ブランコ_3 ブランコ_4 すべり台
  鉄棒_1 鉄棒_2 鉄棒_3 鉄棒_4 鉄棒_5
  シーソー ジャングルジム 複合遊具 砂場 ラダー 健康遊具 プレイスカルプチャー(遊戯彫刻)
  便所 水飲場 ベンチ 四阿 有料駐車場 無料駐車場 
  ソメイヨシノ オオシマザクラ カンヒザクラ シダレザクラ カワズザクラ ヤマザクラ 桜_その他 桜_合計 桜_その他_品種
  is_nice_scenery
);

my $editer = CSVEditer->new({
  columns        => \@COLUMNS,
  get_file_name  => 'data/kouen_jyouhou.csv',
  save_file_name => 'data/fix_park_data.csv',
});

my $API_KEY = 'AIzaSyC-i9RCrsO4yuqMBaNA0EAqJ8mNeCzx-8g';
my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->default_header('Accept-Language' => "ja,en-US;");

sub get_addres {
  my ($y, $x) = @_;
  my $res = $ua->get('https://maps.googleapis.com/maps/api/geocode/json?latlng=' . $y . ',' . $x . '&key=' . $API_KEY);
  my $json = decode_json( $res->is_success ? $res->content : '{}' );
  (split /大阪府/, $json->{results}[0]{formatted_address})[-1];
}

my $park_data = $editer->get_csv_data();
=head1
for my $park (@$park_data) {
  $park->{address} = get_addres($park->{y}, $park->{x}) // '住所';
}
=cut
$editer->save_csv_data($park_data);

