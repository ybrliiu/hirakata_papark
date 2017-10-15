package HirakataPapark::Web::Controller::Searcher {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use HirakataPapark::Service::Searcher;

  has 'service' => sub { HirakataPapark::Service::Searcher->new };

  sub root($self) {
    $self->render;
  }

  sub name($self) {
    $self->render;
  }

  sub address($self) {
    $self->render;
  }

  sub equipment($self) {
    my $result = $self->service->equipment;
    $self->stash($result);
    $self->render;
  }

  sub surrounding_facility($self) {
    my $result = $self->service->surrounding_facility;
    $self->stash($result);
    $self->render;
  }

}

1;

