package HirakataPapark::Model::Users::ParkEditHistories::MetaTables::MetaTables {

  use Mouse::Role;
  use HirakataPapark;
  use Option ();
  use HirakataPapark::Exception;
  use HirakataPapark::Model::Users::ParkEditHistories::MetaTables::BodyTable;

  # constants
  requires qw( BODY_TABLE_NAME FOREIGN_LANG_TABLE_NAMES_MAPPED_TO_LANG );

  # attributes
  requires qw( foreign_lang_tables_mapped_to_lang );

  has 'schema' => (
    is       => 'ro',
    isa      => 'Aniki::Schema',
    required => 1,
  );

  has 'body_table' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Users::ParkEditHistories::MetaTables::BodyTable',
    lazy    => 1,
    builder => '_build_body_table',
  );

  # methods
  requires qw( join_tables is_column_exists_in_duplicate_columns );

  sub _build_body_table($self) {
    HirakataPapark::Model::Users::ParkEditHistories::MetaTables::BodyTable->new({
      name   => $self->BODY_TABLE_NAME,
      schema => $self->schema,
    });
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

  sub foreign_lang_tables($self) {
    my @tables = map {
      $self->foreign_lang_tables_mapped_to_lang->{$_};
    } HirakataPapark::Types->FOREIGN_LANGS->@*;
    \@tables;
  }

  sub get_foreign_lang_table_by_lang($self, $lang) {
    Option::option( $self->foreign_lang_tables_mapped_to_lang->{$lang} )->match(
      Some => sub ($table) { $table },
      None => sub { HirakataPapark::Exception->throw("'$lang' table is not found.") },
    );
  }

  sub tables($self) {
    [ $self->body_table, $self->join_tables->@* ];
  }

}

1;
