package HirakataPapark::Service::Service {

  use Mouse::Role;
  use HirakataPapark;
  use Module::Load;

  use HirakataPapark::Model::Role::DB;

  sub txn_scope {
    HirakataPapark::Model::Role::DB->default_db
                                   ->txn_manager
                                   ->txn_scope;
  }

  sub _generate_loader_method {
    my $class = shift;

    my @loader_methods = qw( model row );
    my %pkg_name;
    @pkg_name{@loader_methods} = qw( Model DB::Row );
    
    for my $method_name (@loader_methods) {
      $class->meta->add_method($method_name => sub {
        my ($class, $name) = @_;
        state $module_names = {};
        return $module_names->{$name} if exists $module_names->{$name};
        my $pkg = "HirakataPapark::$pkg_name{$method_name}::$name";
        Module::Load::load($pkg);
        $module_names->{$name} = $pkg;
      });
    }
  }

  __PACKAGE__->_generate_loader_method();

}

1;

