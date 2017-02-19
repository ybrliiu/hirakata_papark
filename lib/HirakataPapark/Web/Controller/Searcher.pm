package HirakataPapark::Web::Controller::Searcher {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use HirakataPapark::Service::Searcher;

  has 'service' => sub { HirakataPapark::Service::Searcher->new };

  sub equipment {
    my $self = shift;
    my $result = $self->service->equipment;
    $self->stash($result);
    $self->render;
  }

}

1;

