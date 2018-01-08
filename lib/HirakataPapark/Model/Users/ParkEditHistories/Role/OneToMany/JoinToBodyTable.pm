package HirakataPapark::Model::Users::ParkEditHistories::Role::OneToMany::JoinToBodyTable {

  use Mouse::Role;
  use HirakataPapark;
  use SQL::Translator::Schema::Constants qw( FOREIGN_KEY );

  my $BodyTable =
    'HirakataPapark::Model::Users::ParkEditHistories::Role::BodyTable';
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

  requires qw( foreign_key_column_name );

  sub _build_join_condition($self) {
    +{
      $self->table->name . '.' . $self->foreign_key_column_name =>
        $self->body_meta_table->name . '.' . $self->body_meta_table->pkey->name
    };
  }

}

1;
