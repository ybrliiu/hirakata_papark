package HirakataPapark::Container {

  use Mouse;
  use Bread::Board;
  use HirakataPapark;
  use HirakataPapark::Container::Model;
  extends qw( Bread::Board::Container );

  has 'name' => ( is => 'ro', isa => 'Str', default => 'hirakata_papark' );

  with 'HirakataPapark::Role::Singleton';

  sub BUILD($self, $args) {
    $self->add_sub_container(HirakataPapark::Container::Model->new);
    $self->add_sub_container($self->db_container);
  }

  sub db_container($self) {
    container 'DB' => as {

      service 'psql' => (
        block => sub ($s) {
          require HirakataPapark::DB;
          require HirakataPapark::Model::Config;
          my $config = HirakataPapark::Model::Config->instance->get_config('db');
          HirakataPapark::DB->new(%$config);
        },
        lifecycle => 'Singleton',
      );

    };
  }

  __PACKAGE__->meta->make_immutable;

}

1;

