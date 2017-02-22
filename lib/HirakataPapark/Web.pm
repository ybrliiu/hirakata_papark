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

    {
      my $park = $r->any('/park')->to(controller => 'Park');
      $park->get( '/:park_id'            )->to(action => 'show_park_by_id');
      $park->post('/add-comment/:park_id')->to(action => 'add_comment_by_id');
    }

    {
      my $searcher = $r->any('/searcher')->to(controller => 'Searcher');
      $searcher->get('/equipment')->to(action => 'equipment');
    }

    {
      my $search = $r->any('/search')->to(controller => 'Search');
      $search->get('/by-equipments' )->to(action => 'by_equipments');
      $search->get('/has-equipments')->to(action => 'has_equipments');
    }

  }

}

1;
