package HirakataPapark::Model::Users::ParkEditHistories::Role::MetaTables {

  use Mouse::Role;
  use HirakataPapark;
  use Option ();
  use HirakataPapark::Model::Users::ParkEditHistories::Role::BodyTable;

  # constants
  requires qw( BODY_TABLE_NAME FOREIGN_LANG_TABLE_NAMES_MAPPED_TO_LANG );

  has 'schema' => (
    is       => 'ro',
    isa      => 'Aniki::Schema',
    required => 1,
  );

  has 'body_table' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Users::ParkEditHistories::Role::BodyTable',
    lazy    => 1,
    builder => '_build_body_table',
  );

  # attributes
  requires qw(
    foreign_lang_tables_mapped_to_lang
  );

  sub _build_body_table($self) {
    HirakataPapark::Model::Users::ParkEditHistories::Role::BodyTable->new({
      name   => $self->BODY_TABLE_NAME,
      schema => $self->schema,
    });
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

  sub get_foreign_lang_table_by_lang($self, $lang) {
    Option::option( $self->foreign_lang_tables_mapped_to_lang->{$lang} )->match(
      Some => sub ($table) { $table },
      None => sub { "'$lang' table is not found." },
    );
  }

}

1;
