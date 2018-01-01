use lib './lib';
use HirakataPapark;
use HirakataPapark::Model::Config;
my $config = HirakataPapark::Model::Config->instance->get_config('db');
{
  connect_info => $config->{connect_info},
  schema_class => 'HirakataPapark::DB::Schema',
};
