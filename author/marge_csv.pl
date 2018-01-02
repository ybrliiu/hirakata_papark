use lib './lib', './author';
use HirakataPapark;
use CSVEditer;

my $old_editer= CSVEditer->new({
  columns => [qw(
    id name y x address area area_ha is_evacuation_area
    ブランコ_2 ブランコ_3 ブランコ_4 すべり台
    鉄棒_1 鉄棒_2 鉄棒_3 鉄棒_4 鉄棒_5
    シーソー ジャングルジム 複合遊具 砂場 ラダー 健康遊具 プレイスカルプチャー(遊戯彫刻)
    便所 水飲場 ベンチ 四阿 有料駐車場 無料駐車場 
    ソメイヨシノ オオシマザクラ カンヒザクラ シダレザクラ カワズザクラ ヤマザクラ 桜_その他 桜_合計 桜_その他_品種
    is_nice_scenery
  )],
  get_file_name  => 'data/parks_strict_2017_0400.csv',
  save_file_name => 'data/tmp.csv',
});

my $new_editer = CSVEditer->new({
  columns => [qw/
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
  /],
  get_file_name  => 'data/parks_add_zipcode_2017_1212.csv',
  save_file_name => 'data/marged.csv',
});

my $old_parks = $old_editer->get_csv_data;
my $new_parks = $new_editer->get_csv_data;

sub difference_names {
  my %old_table = map { $_->{name} => $_ } @$old_parks;
  my @not_founds = map { exists $old_table{$_} ? () : $_ } map { $_->{name} } @$new_parks;
  say $_ for @not_founds;
}


if ( !difference_names ) {
  shift @$old_parks;
  my $first_line = shift @$new_parks;
  my @sorted_old_parks = sort { $a->{name} cmp $b->{name} } @$old_parks;
  my @sorted_new_parks = sort { $a->{name} cmp $b->{name} } @$new_parks;
  for my $n (0 .. $#sorted_old_parks) {
    my ($old_park, $new_park) = ($sorted_old_parks[$n], $sorted_new_parks[$n]);
    $new_park->{address} = $old_park->{address};
  }
  my @parks = sort { $a->{id} cmp $b->{id} } @sorted_new_parks;
  unshift @parks, $first_line;
  $new_editer->save_csv_data(\@parks);
}

