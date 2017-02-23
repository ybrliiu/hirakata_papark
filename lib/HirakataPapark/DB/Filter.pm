package HirakataPapark::DB::Filter {

  use HirakataPapark;
  use Aniki::Filter::Declare;
  
  use Encode;
  use Time::Piece;

  table park_comment => sub {
    inflate time => sub {
      my $time = shift;
      my $t = localtime($time);
      Encode::decode_utf8 $t->strftime('%d日%H時%M分%S秒');
    };
  };

}

1;

