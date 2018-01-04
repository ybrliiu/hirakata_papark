package HirakataPapark::Util {

  use HirakataPapark;
  use Encode;
  use Time::Piece;

  use Exporter 'import';
  our @EXPORT_OK = qw( datetime escape_indention to_kebab_case );

  # 年月日時曜日時刻出力
  sub datetime($time = localtime) {
    Encode::decode_utf8 $time->strftime('%Y/%m/%d(%a) %H:%M:%S');
  }

  sub to_kebab_case($str) {
    join '-', map { lc $_ } grep { length $_ } split /([A-Z]{1}[^A-Z]*)/, $str;
  }

  
}

1;
