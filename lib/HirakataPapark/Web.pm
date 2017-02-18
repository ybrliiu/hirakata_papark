package HirakataPapark::Web {

  use Mojo::Base 'Mojolicious';

  sub startup {
    my $self = shift;

    $self->plugin(Config => { file => "etc/config/$_.conf" }) for qw( site );
    $self->plugin(AssetPack => { pipes => [qw/Css Sass/] });
    $self->asset->process('base.css' => 'scss/base.scss');
  
    my $r = $self->routes;
    $r->namespaces(['HirakataPapark::Web::Controller']);
    $r->get('/')->to('Root#root');
    $r->get('/current-location')->to('Root#current_location');

    $r->get('/park/:park_id')->to('Park#show_park_by_id');
  }

}

1;
