package HirakataPapark::Web {

  use Mojo::Base 'Mojolicious';

  sub startup {
    my $self = shift;
  
    $self->plugin('PODRenderer');
  
    my $r = $self->routes;
    $r->get('/')->to('example#welcome');
  }

}

1;
