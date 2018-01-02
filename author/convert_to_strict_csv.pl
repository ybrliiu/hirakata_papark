use lib './lib', './author';
use HirakataPapark;
use Data::Dumper;
use CSVEditer;
use Unicode::Japanese;

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
);

my $editer = CSVEditer->new({
  columns        => \@COLUMNS,
  get_file_name  => 'data/parks_2017_1212.csv',
  save_file_name => 'data/parks_strict_2017_1212.csv',
});

my $parks = $editer->get_csv_data;
convert($parks);
$editer->save_csv_data($parks);

sub replace_first_line($parks) {
  my $first_line = $parks->[0];
  for my $key (keys %$first_line) {
    $first_line->{$key} = $key;
  }
}

sub trim($park) {
  for my $key (keys %$park) {
    $park->{$key} =~ s/(　| )//g;
  }
}

sub replace_hankaku_to_zenkaku($park, $key) {
  $park->{$key} = Unicode::Japanese->new($park->{$key})->h2z->getu;
}

sub hankaku_to_zenkaku($park) {
  for my $key (qw/ name_kana 桜_その他_品種 /) {
    replace_hankaku_to_zenkaku($park, $key);
  }
}

sub zenkaku_num_to_hankaku($park) {
  $park->{address} = Unicode::Japanese->new($park->{address})->z2hNum->getu;
}

sub add_to_address($park) {
  $park->{address} = '大阪府枚方市' . $park->{address};
}

sub fix_notation_blur($park) {
  $park->{'桜_その他_品種'} =~ s/アウズミ桜/淡墨桜/g;
}

sub convert($parks) {
  replace_first_line($parks);
  for my $park (@$parks) {
    next if $park->{id} eq 'id';
    trim($park);
    hankaku_to_zenkaku($park);
    zenkaku_num_to_hankaku($park);
    add_to_address($park);
    fix_notation_blur($park);
  }
}
