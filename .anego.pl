use lib 'lib';
use HirakataPapark;
use HirakataPapark::Model::Config;
my $config = HirakataPapark::Model::Config->get;
{
  connect_info => $config->{db}{connect_info},
  schema_class => 'HirakataPapark::DB::Schema',
};
