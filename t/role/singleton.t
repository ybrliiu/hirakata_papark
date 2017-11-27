use HirakataPapark 'test';

package SingletonClass {

  use Mouse;

  has [qw/ a b /] => ( is => 'ro', isa => 'Int', required => 1 );

  with qw( HirakataPapark::Role::Singleton );

  __PACKAGE__->meta->make_immutable;

}

package SingletonClass2 {

  use Mouse;

  has [qw/ c d /] => ( is => 'ro', isa => 'Num', required => 1 );

  with qw( HirakataPapark::Role::Singleton );

  __PACKAGE__->meta->make_immutable;

}

ok my $obj = SingletonClass->instance(a => 10, b => 2);
ok my $obj3 = SingletonClass2->instance(c => 3.4, d => 6.7);
ok my $obj2 = SingletonClass->instance(a => 5, b => 6);
ok my $obj4 = SingletonClass2->instance(c => 1.1, d => 2.2);
is $obj3, $obj4;
is $obj, $obj2;

done_testing;

