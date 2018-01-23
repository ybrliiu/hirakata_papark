package HirakataPapark::Model::Role::DB::TablesMeta::BodyTable {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Model::Role::DB::TablesMeta::MetaTable';
  
  sub _build_select_columns($self) {
    $self->_select_columns_builder($self->table, [$self->table->get_fields]);
  }

  __PACKAGE__->meta->make_immutable;

}

1;
