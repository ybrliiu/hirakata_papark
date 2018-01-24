package HirakataPapark::Model::Role::DB::TablesMeta::Multilingual::HasOne {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use aliased 'HirakataPapark::Model::Role::DB::TablesMeta::BodyTable';
  use aliased 'HirakataPapark::Model::Role::DB::TablesMeta::ForeignLangTable';
  use namespace::autoclean;

  has 'duplicate_columns_with_body_table' => (
    is      => 'ro',
    isa     => 'ArrayRef[Aniki::Schema::Table::Field]',
    lazy    => 1,
    builder => '_build_duplicate_columns_with_body_table',
  );

  has 'duplicate_column_names_with_body_table_mapped' => (
    is      => 'ro',
    isa     => 'HashRef[Bool]',
    lazy    => 1,
    builder => '_build_duplicate_column_names_with_body_table_mapped',
  );

  sub foreign_lang_tables_mapped_to_lang;
  has 'foreign_lang_tables_mapped_to_lang' => (
    is      => 'ro',
    isa     => "HashRef[@{[ ForeignLangTable ]}]",
    lazy    => 1,
    builder => '_build_foreign_lang_tables_mapped_to_lang',
  );

  with 'HirakataPapark::Model::Role::DB::TablesMeta::Multilingual';

  sub _build_duplicate_columns_with_body_table($self) {
    my $foreign_lang_table_name = 
      (values $self->foreign_lang_tables_names_mapped_to_lang->%*)[0];
    my $foreign_lang_table = $self->_get_table($foreign_lang_table_name);
    $self->_get_duplicate_columns([ $self->body_table, $foreign_lang_table ]);
  }

  sub _build_duplicate_column_names_with_body_table_mapped($self) {
    +{ map { $_->name => 1 } $self->duplicate_columns_with_body_table->@* };
  }

  sub _build_foreign_lang_tables_mapped_to_lang($self) {
    my %map = map {
      my $lang = $_;
      my $table_name = $self->foreign_lang_tables_names_mapped_to_lang->{$lang};
      $lang => ForeignLangTable->new({
        name       => $table_name,
        lang       => $lang,
        table      => $self->_get_table($table_name),
        body_table => $self->body_table,
        duplicate_columns_with_body_table => $self->duplicate_columns_with_body_table,
      });
    } HirakataPapark::Types->FOREIGN_LANGS->@*;
    \%map;
  }

  sub is_column_exists_in_duplicate_columns($self, $column_name) {
    $self->duplicate_column_names_with_body_table_mapped->{$column_name};
  }

  sub join_tables($self) {
    $self->foreign_lang_tables;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
