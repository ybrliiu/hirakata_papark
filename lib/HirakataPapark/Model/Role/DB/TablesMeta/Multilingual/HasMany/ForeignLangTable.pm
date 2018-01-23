package HirakataPapark::Model::Role::DB::TablesMeta::Multilingual::HasMany::ForeignLangTable {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;

  has 'lang' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Types::Lang',
    required => 1,
  );

  my $DefaultLangTable =
    'HirakataPapark::Model::Role::DB::TablesMeta::Multilingual::HasMany::DefaultLangTable';
  has 'default_lang_table' => (
    is       => 'ro',
    isa      => $DefaultLangTable,
    required => 1,
  );

  has 'duplicate_columns_with_default_lang_table' => (
    is       => 'ro',
    isa      => 'ArrayRef[Aniki::Schema::Table::Field]',
    required => 1,
  );

  has 'foreign_key_column_name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  with qw(
    HirakataPapark::Model::Role::DB::TablesMeta::MetaTable
    HirakataPapark::Model::Role::DB::TablesMeta::Multilingual::HasMany::JoinableToBodyTable
  );
  
  sub _build_select_columns($self) {
    my @columns = grep {
      $_->name ne $self->foreign_key_column_name;
    } $self->duplicate_columns_with_default_lang_table->@*;
    $self->_select_columns_builder($self->table, \@columns);
  }

  sub _build_join_condition($self) {
    my ($body_table, $default_lang_table) = 
      ($self->body_table, $self->default_lang_table);
    +{
      $self->name . '.' . $self->foreign_key_column_name =>
        $body_table->name . '.' . $body_table->pkey->name,
      $default_lang_table->name . '.' . $default_lang_table->pkey->name => 
        $self->name . '.' . $self->pkey->name,
    };
  }

  __PACKAGE__->meta->make_immutable;

}

1;
