package HirakataPapark::Model::Role::DB::TablesMeta::ForeignLangTable {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;

  has 'lang' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Types::Lang',
    required => 1,
  );

  has 'body_table' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Role::DB::TablesMeta::BodyTable',
    required => 1,
  );

  has 'duplicate_columns_with_body_table' => (
    is       => 'ro',
    isa      => 'ArrayRef[Aniki::Schema::Table::Field]',
    required => 1,
  );

  has 'join_condition' => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    lazy    => 1,
    builder => '_build_join_condition',
  );

  with 'HirakataPapark::Model::Role::DB::TablesMeta::MetaTable';

  sub _build_select_columns($self) {
    $self->_select_columns_builder($self->table, $self->duplicate_columns_with_body_table);
  }

  sub _build_join_condition($self) {
    my $body_table = $self->body_table;
    +{
      $self->name . '.' . $self->pkey->name =>
        $body_table->name . '.' . $body_table->pkey->name,
    };
  }

  __PACKAGE__->meta->make_immutable;

}

1;
