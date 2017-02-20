package HirakataPapark::Web::Controller::Search {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use HirakataPapark::Service::Search;

  has 'service' => sub { HirakataPapark::Service::Search->new };

  sub by_equipments {
    my $self = shift;
    my $result = $self->service->by_equipments( $self->every_param('equipments') );
    $self->stash($result);
    $self->render(template => 'search/result');
  }

  sub has_equipments {
    my $self = shift;
    my $result = $self->service->has_equipments( $self->every_param('equipments') );
    $self->stash($result);
    $self->render(template => 'search/result');
  }

}

1;

