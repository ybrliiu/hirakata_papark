package HirakataPapark::Container {

  use Moose;
  use Bread::Board;
  use HirakataPapark;
  use HirakataPapark::DB;
  use HirakataPapark::Model::Config;
  extends qw( Bread::Board::Container );

  has 'name' => ( is => 'ro', isa => 'Str', default => 'hirakata_papark' );

  sub BUILD($self, $args) {
    $self->add_sub_container($self->db_container);
  }

  sub db_container($self) {
    container 'DB' => as {

      service 'psql' => (
        block => sub ($s) {
          my $config = HirakataPapark::Model::Config->instance->get_config('db');
          HirakataPapark::DB->new(%$config);
        },
        lifecycle => 'Singleton',
      );

      service 'sqlite' => (
        block => sub ($s) {
          my $db_path = './etc/tmp/test.db';
          HirakataPapark::DB->new(connect_info => ["dbi:SQLite:dbname='${db_path}'"]);
        },
        lifecycle => 'Singleton',
      );

    };
  }

  __PACKAGE__->meta->make_immutable;

}

1;

