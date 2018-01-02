use lib './lib', './author';
use HirakataPapark;
use CSVEditer;
use Lingua::JA::Romanize::Japanese;

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
  get_file_name  => 'data/parks_add_address_kana_2017_1212.csv',
  save_file_name => 'data/parks_add_english_data_2017_1212.csv',
});
my $parks = $editer->get_csv_data;
my $conv = Lingua::JA::Romanize::Japanese->new;
add_english_data($parks);
$editer->save_csv_data($parks);

sub add_name($park) {
  state $replace_pairs = [
    [' ', ''],
    ['kouen', ' Park'],
    ['hiroba', ' Square'],
    ['ryokuchi', ' Green Space'],
  ];
  $park->{english_name} = $conv->chars($park->{name_kana});
  for my $pair (@$replace_pairs) {
    my ($one, $two) = @$pair;
    $park->{english_name} =~ s/$one/$two/g;
  }
  $park->{english_name} =~ s/ー/-/g;
  $park->{english_name} = ucfirst $park->{english_name};
}

sub add_address($park) {
  my ($number) = $park->{address} =~ /^[^0-9].*?([0-9]+.*)$/;
  warn " $park->{name} $park->{address}" unless defined $number;
  $number //= '';
  $number =~ s/(−|丁目|番)/-/g;
  my @romajis = map { ucfirst $conv->chars($_) =~ s/ //gr } split /－/, $park->{address_kana};
  $romajis[0] =~ s/fu/-fu/g;
  $romajis[1] =~ s/shi/-shi/g;
  my @parts = ($number, reverse @romajis);
  $park->{english_address} = join ', ', @parts;
}

sub add_english_data($parks) {
  for my $park (@$parks) {
    # 最初の行は飛ばす
    next if $park->{id} eq 'id';
    add_name($park);
    add_address($park);
  }
}
