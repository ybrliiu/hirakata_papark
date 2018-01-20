package HirakataPapark::Model::Users::ParkEditHistories::MetaTables::HasMany::MetaTables {

  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Types;
  use HirakataPapark::Model::Users::ParkEditHistories::MetaTables::BodyTable;
  use HirakataPapark::Model::Users::ParkEditHistories::MetaTables::HasMany::DefaultLangTable;
  use HirakataPapark::Model::Users::ParkEditHistories::MetaTables::HasMany::ForeignLangTable;

  # constants
  requires qw( DEFAULT_LANG_TABLE_NAME );

  my $DefaultLangTable = 
    'HirakataPapark::Model::Users::ParkEditHistories::MetaTables::HasMany::DefaultLangTable';
  has 'default_lang_table' => (
    is      => 'ro',
    isa     => $DefaultLangTable,
    lazy    => 1,
    builder => '_build_default_lang_table',
  );

  has 'duplicate_columns_with_default_lang_table' => (
    is      => 'ro',
    isa     => 'ArrayRef[Aniki::Schema::Table::Field]',
    lazy    => 1,
    builder => '_build_duplicate_columns_with_default_lang_table',
  );

  has 'duplicate_column_names_with_default_lang_table_mapped' => (
    is      => 'ro',
    isa     => 'HashRef[Bool]',
    lazy    => 1,
    builder => '_build_duplicate_column_names_with_default_lang_table_mapped',
  );

  my $ForeignLangTable =
    'HirakataPapark::Model::Users::ParkEditHistories::MetaTables::HasMany::ForeignLangTable';
  sub foreign_lang_tables_mapped_to_lang;
  has 'foreign_lang_tables_mapped_to_lang' => (
    is      => 'ro',
    isa     => "HashRef[$ForeignLangTable]",
    lazy    => 1,
    builder => '_build_foreign_lang_tables_mapped_to_lang',
  );

  with 'HirakataPapark::Model::Users::ParkEditHistories::MetaTables::MetaTables';

  sub _build_default_lang_table($self) {
    $DefaultLangTable->new({
      name       => $self->DEFAULT_LANG_TABLE_NAME,
      schema     => $self->schema,
      body_table => $self->body_table,
    });
  }

  sub _build_duplicate_columns_with_default_lang_table($self) {
    my $foreign_lang_table_name = 
      (values $self->FOREIGN_LANG_TABLE_NAMES_MAPPED_TO_LANG->%*)[0];
    my $foreign_lang_table = $self->body_table->_get_table($foreign_lang_table_name);
    $self->_get_duplicate_columns([ $self->default_lang_table, $foreign_lang_table ]);
  }

  sub _build_duplicate_column_names_with_default_lang_table_mapped($self) {
    +{ map { $_->name => 1 } $self->duplicate_columns_with_default_lang_table->@* };
  }

  sub _build_foreign_lang_tables_mapped_to_lang($self) {
    my %map = map {
      my $lang = $_;
      my $table_name = $self->FOREIGN_LANG_TABLE_NAMES_MAPPED_TO_LANG->{$lang};
      $lang => $ForeignLangTable->new({
        name                    => $table_name,
        lang                    => $lang,
        schema                  => $self->schema,
        body_table              => $self->body_table,
        default_lang_table      => $self->default_lang_table,
        foreign_key_column_name => $self->default_lang_table->foreign_key_column_name,
        duplicate_columns_with_default_lang_table => 
          $self->duplicate_columns_with_default_lang_table,
      });
    } HirakataPapark::Types->FOREIGN_LANGS->@*;
    \%map;
  }

  sub is_column_exists_in_duplicate_columns($self, $column_name) {
    $self->duplicate_column_names_with_default_lang_table_mapped->{$column_name};
  }

  sub join_tables($self) {
    [ $self->default_lang_table, $self->foreign_lang_tables->@* ];
  }

}

1;