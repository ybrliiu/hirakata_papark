# data/kouen_jyouhou.csv の公園の住所データを自動的に補完するプログラム

use lib './lib';
use HirakataPapark;
use Path::Tiny;
use Data::Dumper;
use Encode qw( decode );
use Text::CSV_XS;
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

sub get_csv_data {
  open my $fh, '<', './data/kouen_jyouhou.csv';
  my $parser = Text::CSV_XS->new({
    binary       => 1,
    always_quote => 1,
  });
  my @park_data;
  while (my $columns = $parser->getline($fh)) {
    my %park;
    @park{@COLUMNS} = map { decode('shift-jis', $_) } @$columns;
    push @park_data, \%park;
  }
  $fh->close;
  \@park_data;
}

sub save_csv_data {
  my $park_data = shift;
  my @data = map {
    my %park = %{$_};
    join(',', map { qq{"$park{$_}"} } @COLUMNS) . "\n";
  } @$park_data;
  Path::Tiny::path('data/fix_park_data.csv')->touch->spew(\@data);
}

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

my $park_data = get_csv_data;
=head1
for my $park (@$park_data) {
  $park->{address} = get_addres($park->{y}, $park->{x}) // '住所';
}
=cut

save_csv_data($park_data);

