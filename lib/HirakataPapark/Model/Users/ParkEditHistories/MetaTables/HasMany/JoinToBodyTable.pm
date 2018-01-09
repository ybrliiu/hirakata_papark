package HirakataPapark::Model::Users::ParkEditHistories::MetaTables::HasMany::JoinToBodyTable {

  use Mouse::Role;
  use HirakataPapark;

  my $BodyTable =
    'HirakataPapark::Model::Users::ParkEditHistories::MetaTables::BodyTable';
  has 'body_table' => (
    is       => 'ro',
    isa      => $BodyTable,
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
