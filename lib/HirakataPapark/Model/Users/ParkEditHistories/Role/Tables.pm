package HirakataPapark::Model::Users::ParkEditHistories::Role::Tables {

  use Mouse::Role;
  use HirakataPapark;
  use Option ();

  # constants
  requires qw( BODY_TABLE_NAME FOREIGN_LANGS_TABLE_NAMES );

  has 'body_table' => (
    is      => 'ro',
    isa     => 'Aniki::Schema::Table',
    lazy    => 1,
    builder => '_build_body_table',
  );

  has 'db' => (
    is       => 'ro',
    isa      => 'HirakataPapark::DB',
    required => 1,
  );

  has 'select_columns_makers' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    builder => '_build_select_columns_makers',
  );

  has '_sc_maker' => (
    is      => 'ro',
    lazy    => 1,
    handles => [qw( duplicate_columns duplicate_columns_table )],
    builder => '_build__sc_maker',
  );

  # methods
  requires qw(
    _build_select_columns_makers
    _build__sc_maker
  );

  sub _table_builder($self, $table_name) {
    Option::option( $self->db->schema->get_table($table_name) )->match(
      Some => sub ($table) { $table },
      None => sub { HirakataPapark::Exception->throw("table ${table_name} is not defined.") },
    );
  }

  sub _build_body_table($self) {
    $self->_table_builder($self->BODY_TABLE_NAME);
  }

}

1;
