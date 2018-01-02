# 2017年12月に公開された公園データの住所の読みデータを補完
# 郵便番号検索APIを利用し、住所の読みを取ってくる http://zipcloud.ibsnet.co.jp/doc/api

use lib './lib', './author';
use HirakataPapark;
use CSVEditer;
use LWP::UserAgent;
use Unicode::Japanese;
use Data::Dumper;
use JSON::XS qw( decode_json );
binmode STDOUT, ':utf8';

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
  get_file_name  => 'data/marged.csv',
  save_file_name => 'data/parks_add_address_kana_2017_1212.csv',
});

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->default_header('Accept-Language' => "ja,en-US;");

sub get_address_kana($park) {
  my $zipcode = $park->{zipcode} =~ s/-//gr;
  my $res = $ua->get('http://zipcloud.ibsnet.co.jp/api/search?zipcode=' . $zipcode);
  my $json = decode_json( $res->is_success ? $res->content : '{}' );
  my $result = $json->{results}[0];
  if ($result->{address1} eq '大阪府') {
    my $h_address_kana = join '-', map { $result->{"kana$_"} } 1 .. 3;
    my $address_kana = Unicode::Japanese->new($h_address_kana)->h2z->getu;
    say "[ done ] $park->{name} $address_kana";
    $address_kana;
  } else {
    warn "[ invalid zipcode ] $park->{name} $result->{address1}";
    "";
  }
}

my $parks = $editer->get_csv_data();
for my $park (@$parks) {
  next if $park->{id} eq 'id';
  $park->{address_kana} = get_address_kana($park);
}
$editer->save_csv_data($parks);

