package HirakataPapark::Model::Users::ParkEditHistories::Role::OneToMany::DefaultLangTable {

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
    HirakataPapark::Model::Users::ParkEditHistories::Role::MetaTable
    HirakataPapark::Model::Users::ParkEditHistories::Role::OneToMany::JoinToBodyTable
  );

  sub _build_foreign_key_column_name($self) {
    my ($foreign_key) = grep {
      $_->type eq FOREIGN_KEY
    } $self->table->get_constraints;
    ($foreign_key->reference_fields)[0];
  }
  
  sub _build_select_columns($self) {
    my @columns = 
      grep { $_->name ne $self->foreign_key_column_name } $self->table->get_fields;
    $self->_select_columns_builder($self->table, \@columns);
  }

  __PACKAGE__->meta->make_immutable;

}

1;
