package HirakataPapark::Model::Users::ParkEditHistories::Role::BodyTable {

  use Mouse;
  use HirakataPapark;

  has 'pkey' => (
    is      => 'ro',
    isa     => 'Aniki::Schema::Table::Field',
    lazy    => 1,
    builder => '_build_pkey',
  );

  with 'HirakataPapark::Model::Users::ParkEditHistories::Role::MetaTable';

  sub _get_pkey($self, $table) {
    Option::option( $table->primary_key )->match(
      Some => sub ($pk) { ($pk->fields)[0] },
      None => sub {
        HirakataPapark::Exception
          ->throw("table @{[ $table->name ]} doesn't have primary key.");
      },
    );
  }

  sub _build_pkey($self) {
    $self->_get_pkey($self->table);
  }
  
  sub _build_select_columns($self) {
    $self->_select_columns_builder($self->table, $self->table->get_fields);
  }

  __PACKAGE__->meta->make_immutable;

}

1;
