package Test::HirakataPapark {

  use HirakataPapark;
  use parent qw ( HirakataPapark );
  use Module::Load qw( autoload_remote );

  sub import($class) {
    my $pkg = caller;
    my @load = qw(
      Test::More
      Test::Exception
      Test2::Plugin::UTF8
    );
    autoload_remote($pkg, $_) for @load;
    autoload_remote($pkg, 'Test2::Plugin::Name::FromLine', is_guess_test_line => 1);
    $class->import_pragma;
  }
  
}

1;
