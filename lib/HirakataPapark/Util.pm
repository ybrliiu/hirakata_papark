package HirakataPapark::Util {

  use HirakataPapark;

  use Exporter 'import';
  our @EXPORT_OK = (qw/ datetime escape_indention /);

  use Encode;
  use Time::Piece;

  # 年月日時曜日時刻出力
  sub datetime {
    my $time = shift // localtime;
    Encode::decode_utf8 $time->strftime('%Y/%m/%d(%a) %H:%M:%S');
  }
  
}

1;
