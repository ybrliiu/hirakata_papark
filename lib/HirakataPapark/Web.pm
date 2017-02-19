package HirakataPapark::Web {

  use Mojo::Base 'Mojolicious';
  use HirakataPapark;

  sub startup {
    my $self = shift;

    $self->plugin(Config => { file => "etc/config/$_.conf" }) for qw( site plugin );
    $self->plugin(AssetPack => { pipes => [qw/Css Sass/] });
    $self->asset->process('base.css' => 'scss/base.scss');
    $self->plugin('Mojolicious::Plugin::ProxyPassReverse::SubDir') if $self->config->{plugin}{'ProxyPassReverse::SubDir'};
  
    my $r = $self->routes;
    $r->namespaces(['HirakataPapark::Web::Controller']);
    $r->get('/')->to('Root#root');
    $r->get('/current-location')->to('Root#current_location');

    $r->get('/park/:park_id')->to('Park#show_park_by_id');

    $r->get('/searcher/equipment')->to('Searcher#equipment');

    $r->get('/search/by-equipments')->to('Search#by_equipments');
  }

}

1;
