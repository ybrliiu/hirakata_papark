package HirakataPapark::Model::Users::ParkEditHistories::Role::TablesMeta {

  use Mouse::Role;
  use HirakataPapark;
  use Option ();

  # constants
  requires qw( BODY_TABLE_NAME FOREIGN_LANG_TABLE_NAMES_MAPPED_TO_LANG );

  has 'db' => (
    is       => 'ro',
    isa      => 'HirakataPapark::DB',
    required => 1,
  );

  has 'body_table' => (
    is      => 'ro',
    isa     => 'Aniki::Schema::Table',
    lazy    => 1,
    builder => '_build_body_table',
  );

  has 'foreign_lang_tables_mapped_to_lang' => (
    is      => 'ro',
    isa     => 'HashRef[Aniki::Schema::Table]',
    lazy    => 1,
    builder => '_build_foreign_lang_tables',
  );

  has 'body_table_select_columns' => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    lazy    => 1,
    builder => '_build_body_table_select_columns',
  );

  has 'foreign_lang_tables_select_columns_mapped_to_table_name' => (
    is      => 'ro',
    isa     => 'HashRef[ArrayRef[Str]]',
    lazy    => 1,
    builder => '_build_foreign_lang_tables_select_columns_mapped_to_table_name',
  );

  # methods
  requires qw(
    foreign_lang_tables_select_column
    _build_foreign_lang_tables_select_columns_mapped_to_table_name
  );

  sub _get_table($self, $table_name) {
    Option::option( $self->db->schema->get_table($table_name) )->match(
      Some => sub ($table) { $table },
      None => sub { HirakataPapark::Exception->throw("table ${table_name} is not defined.") },
    );
  }

  sub _get_pkey($self, $table) {
    Option::option( $table->primary_key )->match(
      Some => sub ($pk) { ($pk->fields)[0] },
      None => sub {
        HirakataPapark::Exception
          ->throw("table @{[ $table->name ]} doesn't have primary key.");
      },
    );
  }

  sub _select_columns_builder($self, $table, $columns) {
    [ map { $table->name . '.' . $_->name } @$columns ];
  }

  sub _build_body_table($self) {
    $self->_get_table($self->BODY_TABLE_NAME);
  }

  sub _build_foreign_lang_tables_mapped_to_lang($self) {
    my %tables = map {
      my $table_name = $self->FOREIGN_LANGS_TABLE_NAMES->{$_};
      $_ => $self->_get_table($table_name);
    } HirakataPapark::Types->FOREIGN_LANGS->@*;
    \%tables;
  }

  sub _build_body_table_select_columns($self) {
    $self->_select_columns_builder($self->body_table, $self->body_table->get_fields);
  }

  sub _get_duplicate_columns($self, $tables) {
    my %columns = map {
      my $table = $_;
      my %mapped_columns = map { 
        my $column = $_;
        $column->name => $column;
      } $table->get_fields;
      $table->name => \%mapped_columns;
    } @$tables;
    my @duplicate_columns = map { $columns{ $tables->[0]->name }->{$_} }
      grep { grep { exists $columns{$_->name}->{$_} } @$tables }
      map { $_->name } $tables->[0]->get_fields;
    \@duplicate_columns;
  }

}

1;
