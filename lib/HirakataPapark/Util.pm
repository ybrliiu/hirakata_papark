package HirakataPapark::Util {

  use HirakataPapark;
  use Encode;
  use Time::Piece;

  use Exporter 'import';
  our @EXPORT_OK = (qw/ datetime escape_indention /);

  # 年月日時曜日時刻出力
  sub datetime($time = localtime) {
    Encode::decode_utf8 $time->strftime('%Y/%m/%d(%a) %H:%M:%S');
  }
  
}

1;
