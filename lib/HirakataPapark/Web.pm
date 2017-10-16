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
    $r->get('/about')->to('Root#about');

    {
      my $park = $r->any('/park')->to(controller => 'Park');
      $park->get( '/:park_id'             )->to(action => 'show_park_by_id');
      $park->post('/add-comment/:park_id' )->to(action => 'add_comment_by_id');
      $park->get( '/get-comments/:park_id')->to(action => 'get_comments_by_id');
    }

    {
      my $searcher = $r->any('/searcher')->to(controller => 'Searcher');
      $searcher->get('/'                    )->to(action => 'root');
      $searcher->get('/name'                )->to(action => 'name');
      $searcher->get('/address'             )->to(action => 'address');
      $searcher->get('/equipment'           )->to(action => 'equipment');
      $searcher->get('/surrounding-facility')->to(action => 'surrounding_facility');
    }

    {
      my $search = $r->any('/search')->to(controller => 'Search');
      $search->get('/like-name'                 )->to(action => 'like_name');
      $search->get('/like-address'              )->to(action => 'like_address');
      $search->get('/by-equipments'             )->to(action => 'by_equipments');
      $search->get('/has-equipments'            )->to(action => 'has_equipments');
      $search->get('/has-surrounding-facilities')->to(action => 'has_surrounding_facilities');
    }

  }

}

1;
