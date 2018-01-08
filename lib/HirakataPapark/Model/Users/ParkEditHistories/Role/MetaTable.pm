package HirakataPapark::Model::Users::ParkEditHistories::Role::MetaTable {

  use Mouse::Role;
  use HirakataPapark;

  has 'name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  has 'schema' => (
    is       => 'ro',
    isa      => 'Aniki::Schema',
    required => 1,
  );

  has 'table' => (
    is      => 'ro',
    isa     => 'Aniki::Schema::Table',
    lazy    => 1,
    handles => [qw( get_fields )],
    builder => '_build_table',
  );

  has 'select_columns' => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    lazy    => 1,
    builder => '_build_select_columns',
  );

  # methods
  requires qw( _build_select_columns );

  sub _build_table($self) {
    $self->_get_table($self->name);
  }

  sub _get_table($self, $table_name) {
    Option::option( $self->schema->get_table($table_name) )->match(
      Some => sub ($table) { $table },
      None => sub { HirakataPapark::Exception->throw("table ${table_name} is not defined.") },
    );
  }

  sub _select_columns_builder($self, $table, $columns) {
    [ map { $table->name . '.' . $_->name } @$columns ];
  }

}

1;

__END__
