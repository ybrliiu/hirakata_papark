package HirakataPapark::Model::Users::ParkEditHistories::MetaTables::BodyTable {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Model::Users::ParkEditHistories::MetaTables::MetaTable';
  
  sub _build_select_columns($self) {
    $self->_select_columns_builder($self->table, [$self->table->get_fields]);
  }

  __PACKAGE__->meta->make_immutable;

}

1;
