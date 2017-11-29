package HirakataPapark::Service::Park::Searcher::PlantsRowsToPlantsCategories {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Service::Park::Searcher::PlantsCategory;

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
    [ map { HirakataPapark::Service::Park::Searcher::PlantsCategory->new($_) } values %$params ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

