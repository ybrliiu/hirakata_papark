package HirakataPapark::Role::Singleton {

  use Mouse::Role;
  use HirakataPapark;

  sub instance {
    my $class = shift;
    state $instances = {};
    return $instances->{$class} if exists $instances->{$class};
    $instances->{$class} = $class->new(@_);
  }

}

1;

