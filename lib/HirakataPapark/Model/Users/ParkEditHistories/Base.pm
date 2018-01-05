# あとで Model::Role::DB と共通させるべき部分は共通化させる

package HirakataPapark::Model::Users::ParkEditHistories::Base {

  use Mouse::Role;

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

  sub _table_builder($self, $table_name) {
    option( $self->db->schema->get_table($table_name) )->match(
      Some => sub ($table) { $table },
      None => sub { HirakataPapark::Exception->throw("table ${table_name} is not defined.") },
    );
  }

  sub _build_table($self) {
    $self->_table_builder($self->TABLE_NAME);
  }

}

1;
