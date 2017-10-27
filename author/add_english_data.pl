use lib './lib', './author';
use HirakataPapark;
use CSVEditer;
use Lingua::JA::Romanize::Japanese;
use Unicode::Japanese;

my @COLUMNS = qw(
  id name y x address area area_ha is_evacuation_area
  ブランコ_2 ブランコ_3 ブランコ_4 すべり台
  鉄棒_1 鉄棒_2 鉄棒_3 鉄棒_4 鉄棒_5
  シーソー ジャングルジム 複合遊具 砂場 ラダー 健康遊具 プレイスカルプチャー(遊戯彫刻)
  便所 水飲場 ベンチ 四阿 有料駐車場 無料駐車場 
  ソメイヨシノ オオシマザクラ カンヒザクラ シダレザクラ カワズザクラ ヤマザクラ 桜_その他 桜_合計 桜_その他_品種
  is_nice_scenery
  english_name
  english_address
);

my $editer = CSVEditer->new({
  columns        => \@COLUMNS,
  get_file_name  => 'data/manually_fix_park_data.csv',
  save_file_name => 'data/add_english_park_data.csv',
});

my $park_data = $editer->get_csv_data();
my $conv = Lingua::JA::Romanize::Japanese->new;
my @replace_pairs = (
  [' ', ''],
  ['kouen', ' park'],
  ['hiroba', ' square'],
  ['ryokuchi', ' green space'],
);
for my $park (@$park_data) {

  # 最初の行は飛ばす
  next if $park->{id} eq 'NO';

  $park->{english_name} = $conv->chars($park->{name});
  for my $pair (@replace_pairs) {
    my ($one, $two) = @$pair;
    $park->{english_name} =~ s/$one/$two/g;
  }

  $park->{address} = '大阪府' . $park->{address};
  my $address = Unicode::Japanese->new($park->{address})->z2hNum->getu =~ s/(−|丁目)/-/gr;
  $park->{english_address} = join ', ', reverse(split / /, $conv->chars($address));
  $park->{english_address} =~ s/ohsakafuhirakatashi/hirakata-shi, osaka-fu/g;

}
$editer->save_csv_data($park_data);

