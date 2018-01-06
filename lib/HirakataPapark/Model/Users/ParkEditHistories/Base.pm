package HirakataPapark::Model::Users::ParkEditHistories::Base {

  use Mouse::Role;
  use Option ();
  use HirakataPapark;
  use HirakataPapark::Model::Result;

  # constants
  requires qw( TABLE_NAME );

  has 'db' => (
    is       => 'ro',
    isa      => 'HirakataPapark::DB',
    required => 1,
  );

  has 'table' => (
    is      => 'ro',
    isa     => 'Aniki::Schema::Table',
    lazy    => 1,
    builder => '_build_table',
  );

  has 'select_columns_makers' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    builder => '_build_select_columns_makers',
  );

  # methods
  requires qw( _build_select_columns_makers );

  sub _table_builder($self, $table_name) {
    Option::option( $self->db->schema->get_table($table_name) )->match(
      Some => sub ($table) { $table },
      None => sub { HirakataPapark::Exception->throw("table ${table_name} is not defined.") },
    );
  }

  sub _build_table($self) {
    $self->_table_builder($self->TABLE_NAME);
  }

  sub create_result($self, $contents) {
    HirakataPapark::Model::Result->new(contents => $contents);
  }

}

1;
