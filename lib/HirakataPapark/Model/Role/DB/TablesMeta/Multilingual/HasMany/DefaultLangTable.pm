package HirakataPapark::Model::Role::DB::TablesMeta::Multilingual::HasMany::DefaultLangTable {

  use Mouse;
  use HirakataPapark;
  use SQL::Translator::Schema::Constants qw( FOREIGN_KEY );

  has 'foreign_key_column_name' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    builder => '_build_foreign_key_column_name',
  );

  with qw(
    HirakataPapark::Model::Role::DB::TablesMeta::MetaTable
    HirakataPapark::Model::Role::DB::TablesMeta::Multilingual::HasMany::JoinableToBodyTable
  );

  sub _build_join_condition($self) {
    +{
      $self->table->name . '.' . $self->foreign_key_column_name =>
        $self->body_table->name . '.' . $self->body_table->pkey->name
    };
  }

  sub _build_foreign_key_column_name($self) {
    my ($foreign_key) = grep {
      $_->type eq FOREIGN_KEY
    } $self->table->get_constraints;
    $foreign_key->fields->[0]->name;
  }
  
  sub _build_select_columns($self) {
    my @columns = grep {
      my $column_name = $_->name;
      !grep { $column_name eq $_ } ($self->foreign_key_column_name, $self->pkey->name);
    } $self->table->get_fields;
    $self->_select_columns_builder($self->table, \@columns);
  }

  __PACKAGE__->meta->make_immutable;

}

1;
