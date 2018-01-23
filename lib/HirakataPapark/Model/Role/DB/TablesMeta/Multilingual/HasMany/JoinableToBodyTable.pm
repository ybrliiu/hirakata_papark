package HirakataPapark::Model::Role::DB::TablesMeta::Multilingual::HasMany::JoinableToBodyTable {

  use Mouse::Role;
  use HirakataPapark;

  has 'body_table' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Role::DB::TablesMeta::BodyTable',
    required => 1,
  );

  has 'join_condition' => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    lazy    => 1,
    builder => '_build_join_condition',
  );

  # attributes
  requires qw( foreign_key_column_name );

  # methods
  requires qw( _build_join_condition );

}

1;
