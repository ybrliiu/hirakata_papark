package HirakataPapark::Web::Controller::Root {

  use Mojo::Base 'Mojolicious::Controller';
  use HirakataPapark;
  use HirakataPapark::Service::Root;

  has 'service' => sub { HirakataPapark::Service::Root->new };

  sub root {
    my $self = shift;
    $self->stash(
      $self->service->root->%*,
      msg => 'test',
    );
    $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
  }

}

1;
