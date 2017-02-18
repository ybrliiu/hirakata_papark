package HirakataPapark::Web::Controller::Park {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use HirakataPapark::Service::Park;

  has 'service' => sub { HirakataPapark::Service::Park->new };

  sub show_park_by_id {
    my $self = shift;
    my $result = $self->service->get_park_by_id( $self->param('park_id') );
    $self->stash($result);
    $self->render;
  }

}

1;

