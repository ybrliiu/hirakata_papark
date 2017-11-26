package HirakataPapark::Service::Park::PlantsRowsToPlantsCategories {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Service::Park::PlantsCategory;

  has 'rows' => ( is => 'ro', isa => 'HirakataPapark::Model::Result', required => 1 );

  sub exec($self) {
    my @rows = $self->rows->@*;
    my $params = +{
      map {
        $_->category => +{
          name      => $_->category,
          varieties => [],
        }
      } @rows
    };
    for my $row (@rows) {
      push $params->{$row->category}{varieties}->@*, $row->name;
    }
    [ map { HirakataPapark::Service::Park::PlantsCategory->new($_) } values %$params ];
  }

  sub exec_for_english($self) {
    my @rows = $self->rows->@*;
    my $params = +{
      map {
        $_->category => +{
          name      => $_->english_category,
          varieties => [],
        }
      } @rows
    };
    for my $row (@rows) {
      push $params->{$row->english_category}{varieties}->@*, $row->english_name;
    }
    [ map { HirakataPapark::Service::Park::PlantsCategory->new($_) } values %$params ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

