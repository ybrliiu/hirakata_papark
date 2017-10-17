package HirakataPapark::Web::Controller::Search {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use HirakataPapark::Service::Search;

  has 'service' => sub { HirakataPapark::Service::Search->new };

  sub like_name {
    my $self = shift;
    my $result = $self->service->like_name( $self->param('park_name') );
    $self->stash($result);
    $self->render(template => 'search/result');
  }

  sub like_address {
    my $self = shift;
    my $result = $self->service->like_address( $self->param('park_address') );
    $self->stash($result);
    $self->render(template => 'search/result');
  }

  sub by_equipments {
    my $self = shift;
    my $result = $self->service->by_equipments( $self->every_param('equipments') );
    $self->stash($result);
    $self->render(template => 'search/result');
  }

  sub has_tags {
    my $self = shift;
    my $result = $self->service->has_tags( $self->every_param('tags') );
    $self->stash($result);
    $self->render(template => 'search/result');
  }

  sub has_plants {
    my $self = shift;
    my $result = $self->service->has_plants( $self->every_param('plants') );
    $self->stash($result);
    $self->render(template => 'search/result');
  }

  sub has_plants_categories {
    my $self = shift;
    my $result = $self->service->has_plants_categories( $self->every_param('plants_categories') );
    $self->stash($result);
    $self->render(template => 'search/result');
  }

  sub has_equipments {
    my $self = shift;
    my $result = $self->service->has_equipments( $self->every_param('equipments') );
    $self->stash($result);
    $self->render(template => 'search/result');
  }

  sub has_surrounding_facilities {
    my $self = shift;
    my $result = $self->service->has_surrounding_facilities( $self->every_param('surrounding_facilities') );
    $self->stash($result);
    $self->render(template => 'search/result');
  }

}

1;

