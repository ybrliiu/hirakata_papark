package Test::HirakataPapark::Model::Parks {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Model::Parks;

  use constant {
    TEST_PARK_PARMS => +{
      x       => 0.0000,
      y       => 1.3030,
      name    => 'ほげ公園',
      area    => 1000,
      address => 'A市B町20',
    },
  };

  has 'parks_model' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Parks',
    lazy    => 1,
    builder => sub ($self) { HirakataPapark::Model::Parks->new },
  );

  sub add_test_park ($self) {
    $self->parks_model->add_row( $self->TEST_PARK_PARMS );
    $self->TEST_PARK_PARMS;
  }

  __PACKAGE__->meta->make_immutable;
  
}

1;


