package HirakataPapark::Model::Role::DB::TablesMeta::ForeignLang {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use SQL::Translator::Schema::Constants qw( FOREIGN_KEY );
  use aliased 'HirakataPapark::Model::Role::DB::TablesMeta::ForeignLangTable';
  use namespace::autoclean;

  has 'lang' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Types::Lang',
    required => 1,
  );

  has 'duplicate_columns_with_body_table' => (
    is      => 'ro',
    isa     => 'ArrayRef[Aniki::Schema::Table::Field]',
    lazy    => 1,
    builder => '_build_duplicate_columns_with_body_table',
  );

  has 'foreign_lang_table_name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  has 'foreign_lang_table' => (
    is      => 'ro',
    isa     => ForeignLangTable,
    lazy    => 1,
    builder => '_build_foreign_lang_table',
  );

  with 'HirakataPapark::Model::Role::DB::TablesMeta::TablesMeta';

  sub _build_foreign_lang_table($self) {
    ForeignLangTable->new({
      name       => $self->foreign_lang_table_name,
      lang       => $self->lang,
      table      => $self->_get_table( $self->foreign_lang_table_name ),
      body_table => $self->body_table,
      duplicate_columns_with_body_table => $self->duplicate_columns_with_body_table,
    });
  }

  sub _build_duplicate_columns_with_body_table($self) {
    my $foreign_lang_table = $self->_get_table( $self->foreign_lang_table_name );
    my $columns = $self->_get_duplicate_columns([ $self->body_table, $foreign_lang_table ]);
    my $foreign_key_column_name = do {
      my ($foreign_key) =
        grep { $_->type eq FOREIGN_KEY } $foreign_lang_table->get_constraints;
      $foreign_key->fields->[0]->name;
    };
    [ grep { $_->name ne $foreign_key_column_name } @$columns ];
  }

  sub tables($self) {
    [ $self->body_table, $self->foreign_lang_table ];
  }

  sub select_columns($self) {
    [ map { $_->select_columns->@* } $self->tables->@* ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;
