package HirakataPapark::Model::Users::ParkEditHistories::Role::OneToOne::TablesMeta {

  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Types;

  has 'duplicate_columns_with_body_table' => (
    is      => 'ro',
    isa     => 'ArrayRef[Aniki::Schema::Table::Field]',
    lazy    => 1,
    builder => '_build_duplicate_columns_with_body_table',
  );

  has 'duplicate_columns_with_body_table_mapped_to_name' => (
    is      => 'ro',
    isa     => 'HashRef[Aniki::Schema::Table::Field]',
    lazy    => 1,
    builder => '_build_duplicate_columns_with_body_table_mapped_to_name',
  );

  with 'HirakataPapark::Model::Users::ParkEditHistories::Role::TablesMeta';

  sub foreign_lang_tables_select_column($self, $table) {
    my @columns =
      map { $_->table->name . '.' . $_->name } $self->duplicate_columns_with_body_table->@*;
    \@columns;
  }

  sub _build_foreign_lang_tables_select_columns_mapped_to_table_name($self) {
    my %map = map {
      my $table = $self->foreign_lang_tables_mapped_to_lang->{$_};
      my $columns = $self->foreign_lang_tables_select_column($table);
      $table->name => $columns;
    } HirakataPapark::Types->FOREIGN_LANGS->@*;
    \%map;
  }

  sub _build_duplicate_columns_with_body_table($self) {
    my $foreign_lang_table =
      (values $self->foreign_lang_tables_mapped_to_lang->%*)[0];
    $self->_get_duplicate_columns([ $self->body_table, $foreign_lang_table ]);
  }

  sub _build_duplicate_columns_with_body_table_mapped_to_name($self) {
    +{ map { $_->name => $_ } $self->duplicate_columns_with_body_table->@* };
  }

}

1;
