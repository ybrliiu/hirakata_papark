package HirakataPapark::Util {

  use HirakataPapark;
  use Encode;
  use Time::Piece;

  use Exporter qw( import );
  our @EXPORT_OK = qw( datetime escape_indention to_kebab_case for_each for_yield );

  # 年月日時曜日時刻出力
  sub datetime($time = localtime) {
    Encode::decode_utf8 $time->strftime('%Y/%m/%d(%a) %H:%M:%S');
  }

  sub to_kebab_case($str) {
    join '-', map { lc $_ } grep { length $_ } split /([A-Z]{1}[^A-Z]*)/, $str;
  }

  sub _rec_for_each {
    my ($iters, $index, $params, $code) = @_;
    if ($index == @$iters - 1) {
      $iters->[$index]->foreach(sub {
        my $c = shift;
        $code->(@$params, $c);
      });
    } else {
      $iters->[$index]->foreach(sub {
        my $c = shift;
        push @$params, $c;
        _rec_for_each($iters, $index + 1, $params, $code);
      });
    }
  }

  sub for_each {
    my ($iters, $code) = @_;
    _rec_for_each($iters, 0, [], $code);
  }

  sub _rec_for_yield {
    my ($iters, $index, $params, $code) = @_;
    if ($index == @$iters - 1) {
      $iters->[$index]->map(sub {
        my $c = shift;
        $code->(@$params, $c);
      });
    } else {
      $iters->[$index]->flat_map(sub {
        my $c = shift;
        push @$params, $c;
        _rec_for_yield($iters, $index + 1, $params, $code);
      });
    }
  }

  sub for_yield {
    my ($iters, $code) = @_;
    _rec_for_yield($iters, 0, [], $code);
  }
  
}

1;

__END__

=encoding utf8

=head1 NAME
  
=head1 SINOPSYS

=head1 FUNCTIONS
  
=head2 for_each, for_yield
  
  like scala for expression.

  for ( i1 <- v1; i2 <- v2; i3 <- v3 ) yield { i1 * i2 * i3 }

  is

  my ($v1, $v2, $v3) = map { option $_ } (2, 4, 6);
  my $result = for_each [$v1, $v2, $v3], sub ($i1, $i2, $i3) {
    $i1 * $i2 * $i3;
  };
  # returns: Option::Option(48)

=cut

