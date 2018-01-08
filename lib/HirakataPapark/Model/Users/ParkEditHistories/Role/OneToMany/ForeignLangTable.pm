package HirakataPapark::Model::Users::ParkEditHistories::Role::OneToMany::ForeignLangTable {

  use Mouse;
  use HirakataPapark;

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
    HirakataPapark::Model::Users::ParkEditHistories::Role::MetaTable
    HirakataPapark::Model::Users::ParkEditHistories::Role::OneToMany::JoinToBodyTable
  );
  
  sub _build_select_columns($self) {
    $self->_select_columns_builder(
      $self->table,
      $self->duplicate_columns_with_default_lang_table
    );
  }

  __PACKAGE__->meta->make_immutable;

}

1;
