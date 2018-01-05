use Test::HirakataPapark;
use HirakataPapark::Exception;

dies_ok { HirakataPapark::Exception->throw('test throw') };
my $e = $@;
my $str = << "EOS";
[HirakataPapark::Exception]

message : test throw

stacktrace : test throw at t/exception.t line 4.
\tTest::Exception::dies_ok() called at t/exception.t line 4


EOS

ok $e->isa('HirakataPapark::Exception');
is $e->message, 'test throw';
is $e, $str;

done_testing;
