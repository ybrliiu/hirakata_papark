package HirakataPapark::Web {

  use Mojo::Base 'Mojolicious';

  sub startup {
    my $self = shift;
  
    $self->plugin('PODRenderer');
  
    my $r = $self->routes;
    $r->namespaces(['HirakataPapark::Web::Controller']);
    $r->get('/')->to('Root#root');
  }

}

1;
