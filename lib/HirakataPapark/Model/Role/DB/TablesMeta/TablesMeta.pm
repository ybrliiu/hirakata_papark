package HirakataPapark::Model::Role::DB::TablesMeta::TablesMeta {

  use Mouse::Role;
  use HirakataPapark;
  use Option;
  use HirakataPapark::Exception;
  use aliased 'HirakataPapark::Model::Role::DB::TablesMeta::BodyTable';
  use namespace::autoclean;

  has 'schema' => (
    is       => 'ro',
    isa      => 'Aniki::Schema',
    required => 1,
  );

  has 'body_table_name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  has 'body_table' => (
    is      => 'ro',
    isa     => BodyTable,
    lazy    => 1,
    builder => '_build_body_table',
  );

  # methods
  requires qw( tables );

  sub _build_body_table($self) {
    BodyTable->new({
      name  => $self->body_table_name,
      table => $self->_get_table($self->body_table_name),
    });
  }

  sub _get_table($self, $table_name) {
    option( $self->schema->get_table($table_name) )->match(
      Some => sub ($table) { $table },
      None => sub { HirakataPapark::Exception->throw("table ${table_name} is not defined.") },
    );
  }

  sub _get_duplicate_columns($self, $tables) {
    my @tables = @$tables;
    my %columns = map {
      my $table = $_;
      my %mapped_columns = map { 
        my $column = $_;
        $column->name => $column;
      } $table->get_fields;
      $table->name => \%mapped_columns;
    } @tables;
    my @duplicate_columns = map { $columns{ $tables[0]->name }->{$_} }
      grep {
        my $column_name = $_;
        my $exists_num =
          grep { exists $columns{$_->name}->{$column_name} } @tables;
        $exists_num == @tables;
      } map { $_->name } $tables[0]->get_fields;
    \@duplicate_columns;
  }

}

1;
