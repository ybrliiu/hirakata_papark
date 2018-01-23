package HirakataPapark::Model::Role::DB::TablesMeta::MetaTable {

  use Mouse::Role;
  use HirakataPapark;

  has 'name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  has 'table' => (
    is       => 'ro',
    isa      => 'Aniki::Schema::Table',
    handles  => [qw( get_fields )],
    required => 1,
  );

  has 'pkey' => (
    is      => 'ro',
    isa     => 'Aniki::Schema::Table::Field',
    lazy    => 1,
    builder => '_build_pkey',
  );

  has 'select_columns' => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    lazy    => 1,
    builder => '_build_select_columns',
  );

  # methods
  requires qw( _build_select_columns );

  sub _build_pkey($self) {
    $self->_get_pkey($self->table);
  }

  sub _get_pkey($self, $table) {
    Option::option( $table->primary_key )->match(
      Some => sub ($pk) { ($pk->fields)[0] },
      None => sub {
        HirakataPapark::Exception
          ->throw("table @{[ $table->name ]} doesn't have primary key.");
      },
    );
  }

  sub _select_columns_builder($self, $table, $columns) {
    [ map { $table->name . '.' . $_->name } @$columns ];
  }

}

1;

__END__
