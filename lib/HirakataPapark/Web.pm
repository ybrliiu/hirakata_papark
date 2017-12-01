package HirakataPapark::Web {

  use Mojo::Base 'Mojolicious';
  use HirakataPapark;

  sub startup {
    my $self = shift;

    # load plusings and configuration
    $self->plugin(Config => { file => "etc/config/$_.conf" }) for qw( site plugin hypnotoad );
    $self->plugin(AssetPack => { pipes => [qw/Css Sass/] });
    $self->asset->process('base.css' => 'scss/base.scss');
    $self->plugin('Mojolicious::Plugin::ProxyPassReverse::SubDir') if $self->config->{plugin}{'ProxyPassReverse::SubDir'};

    # override $c->reply->not_found();
    $self->helper('reply.not_found' => sub {
      my $c = shift;
      my $url = $c->req->url->path->to_string();
      my $lang = do {
        my $lang = (split q!/!, $url)[1];
        exists HirakataPapark->LANG_TABLE->{$lang} ? $lang : HirakataPapark->DEFAULT_LANG;
      };
      Mojolicious::Plugin::DefaultHelpers::_development("not_found_${lang}", $c);
    });
  
    # routing
    my $r = $self->routes;
    $r->namespaces(['HirakataPapark::Web::Controller']);

    $r->get('/')->to('Root#top');

    my $root = $r->any('/:lang');

    {
      my $root = $root->to(controller => 'Root');
      $root->get('/'                )->to(action => 'root');
      $root->get('/current-location')->to(action => 'current_location');
      $root->get('/about'           )->to(action => 'about');
    }

    {
      my $park = $root->any('/park')->to(controller => 'Park');
      $park->get( '/:park_id'             )->to(action => 'show_park_by_id');
      $park->get( '/plants/:park_id'      )->to(action => 'show_park_plants_by_id');
      $park->post('/add-comment/:park_id' )->to(action => 'add_comment_by_id');
      $park->get( '/get-comments/:park_id')->to(action => 'get_comments_by_id');
    }

    {
      my $searcher = $root->any('/searcher')->to(controller => 'Searcher');
      $searcher->get('/'                    )->to(action => 'root');
      $searcher->get('/tag'                 )->to(action => 'tags');
      $searcher->get('/name'                )->to(action => 'name');
      $searcher->get('/plants'              )->to(action => 'plants');
      $searcher->get('/address'             )->to(action => 'address');
      $searcher->get('/equipment'           )->to(action => 'equipment');
      $searcher->get('/surrounding-facility')->to(action => 'surrounding_facility');
    }

    {
      my $search = $root->any('/search')->to(controller => 'Search');
      $search->post('/like-name'                 )->to(action => 'like_name');
      $search->post('/like-address'              )->to(action => 'like_address');
      $search->post('/by-equipments'             )->to(action => 'by_equipments');
      $search->post('/near-parks'                )->to(action => 'near_parks');
      $search->post('/has-tags'                  )->to(action => 'has_tags');
      $search->post('/has-plants'                )->to(action => 'has_plants');
      $search->post('/has-equipments'            )->to(action => 'has_equipments');
      $search->post('/has-plants-categories'     )->to(action => 'has_plants_categories');
      $search->post('/has-surrounding-facilities')->to(action => 'has_surrounding_facilities');
    }

    {
      my $user = $root->any('/user')->to(controller => 'User');
      $user;
    }

  }

}

1;
