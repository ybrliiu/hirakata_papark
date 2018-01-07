package HirakataPapark::Model::Users::ParkEditHistories::Role::OneToMany::TablesMeta {

  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Types;
  use SQL::Translator::Schema::Constants qw( FOREIGN_KEY );

  # constants
  requires qw( DEFAULT_LANG_TABLE_NAME );

  has 'default_lang_table' => (
    is      => 'ro',
    isa     => 'Aniki::Schema::Table',
    lazy    => 1,
    builder => '_build_default_lang_table',
  );

  has 'default_lang_table_select_columns' => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    lazy    => 1,
    builder => '_build_default_lang_table_select_columns',
  );

  has 'duplicate_columns_with_default_lang_table' => (
    is      => 'ro',
    isa     => 'ArrayRef[Aniki::Schema::Table::Field]',
    lazy    => 1,
    builder => '_build_duplicate_columns_with_default_lang_table',
  );

  has 'duplicate_columns_with_default_lang_table_mapped_to_name' => (
    is      => 'ro',
    isa     => 'HashRef[Aniki::Schema::Table::Field]',
    lazy    => 1,
    builder => '_build_duplicate_columns_with_default_lang_table_mapped_to_name',
  );

  with 'HirakataPapark::Model::Users::ParkEditHistories::Role::TablesMeta';

  sub _build_default_lang_table($self) {
    $self->_get_table($self->DEFAULT_LANG_TABLE_NAME);
  }

  sub _build_default_lang_table_select_columns($self) {
    my ($foreign_key) = grep {
      $_->type eq FOREIGN_KEY
    } $self->default_lang_table->get_constraints;
    my $remove_column_name = ($foreign_key->reference_fields)[0];
    my @columns = 
      grep { $_->name ne $remove_column_name } $self->default_lang_table->get_fields;
    $self->_select_columns_builder($self->default_lang_table, \@columns);
  }

  sub foreign_lang_tables_select_column($self, $table) {
    $self->_select_columns_builder($table, $self->duplicate_columns_with_default_lang_table);
  }

  sub _build_foreign_lang_tables_select_columns_mapped_to_table_name($self) {
    my %map = map {
      my $table = $self->foreign_lang_tables_mapped_to_lang->{$_};
      my $columns = $self->foreign_lang_tables_select_column($table);
      $table->name => $columns;
    } HirakataPapark::Types->FOREIGN_LANGS->@*;
    \%map;
  }

  sub _build_duplicate_columns_with_default_lang_table($self) {
    my $foreign_lang_table =
      (values $self->foreign_lang_tables_mapped_to_lang->%*)[0];
    $self->_get_duplicate_columns([ $self->default_lang_table, $foreign_lang_table ]);
  }

  sub _build_duplicate_columns_with_default_lang_table_mapped_to_name($self) {
    my %map = map {
      $_->name => $_
    } $self->duplicate_columns_with_default_lang_table->@*;
    \%map;
  }

}

1;
