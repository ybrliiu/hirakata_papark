package HirakataPapark::Web::Controller::Root {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use HirakataPapark::Service::Root;

  has 'service' => sub { HirakataPapark::Service::Root->new };

  sub root {
    my $self = shift;
    $self->stash($self->service->root);
    $self->render_to_multiple_lang();
  }

  sub current_location {
    my $self = shift;
    $self->root();
  }

  sub about {
    my $self = shift;
    $self->render_to_multiple_lang();
  }

}

1;
