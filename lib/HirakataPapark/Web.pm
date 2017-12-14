package HirakataPapark::Web {

  use Mojo::Base 'Mojolicious';
  use HirakataPapark;

  use Plack::Session;
  use Plack::Session::Store::File;
  use Plack::Session::State::Cookie;
  use HirakataPapark::Web::Controller;

  use constant SESSION_EXPIRES_TIME => 60 * 60 * 24;

  sub load_and_set_up_plugins($self) {
    $self->plugin(Config => { file => "etc/config/$_.conf" }) for qw( site plugin hypnotoad );
    $self->plugin( AssetPack =>
        { pipes => [qw/ Css Sass HirakataPapark::Web::Plugin::AssetPack::Pipe::BundleJS /] } );
    $self->asset->process('base.css' => 'scss/base.scss');
    $self->asset->process('bundle.js' => 'js/bundle.js');
    $self->plugin('ProxyPassReverse::SubDir') if $self->config->{plugin}{'ProxyPassReverse::SubDir'};
    # Mojoliciousにはsession機能が無いため, Plack::Middlewareのを代用する
    $self->plugin(PlackMiddleware => [
      Session => {
        state => Plack::Session::State::Cookie->new(
          expiers     => SESSION_EXPIRES_TIME,
          seacret     => 'HirakataPapark::SEACRET_STRING',
          # secure      => 1,
          session_key => 'hirakata_papark_sid',
        ),
        store => Plack::Session::Store::File->new(dir => './etc/sessions'),
      },
    ]);
  }

  sub regist_helpes($self) {

    # override $c->reply->not_found();
    $self->helper('reply.not_found' => sub ($c) {
      $c->render_later;
      my $ext_c = HirakataPapark::Web::Controller->new(
        app   => $c->app,
        tx    => $c->tx,
        match => $c->match,
      );
      $ext_c->stash($c->stash);
      my $lang = (split q!/!, $c->req->url->path->to_string)[1];
      $ext_c->param(lang => $lang);
      $ext_c->render_not_found;
    });
    
    $self->helper(plack_session => sub ($c) {
      Plack::Session->new($c->req->env);
    });

  }

  sub routing($self) {

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
      $user->get( '/register')->to(action => 'register');
      $user->post('/regist'  )->to(action => 'regist');
      $user->get( '/session' )->to(action => 'action_session');
      $user->post('/login'   )->to(action => 'login');
      $user->get( '/logout'  )->to(action => 'logout');
      {
        my $authed_user = $root->under('/user')->to(controller => 'AuthedUser')->to(action => 'auth');
        $authed_user->get( '/mypage'                   )->to(action => 'mypage');
        $authed_user->post('/add-park-star/:park_id'   )->to(action => 'add_park_star');
        $authed_user->post('/remove-park-star/:park_id')->to(action => 'remove_park_star');
        $authed_user->get( '/park-tagger/:park_id'     )->to(action => 'park_tagger');
        $authed_user->post('/add-park-tag/:park_id'    )->to(action => 'add_park_tag');
        $authed_user->get( '/park-editer/:park_id'     )->to(action => 'park_editer');
      }
      {
        my $twitter = $user->any('/twitter')->to(controller => 'User::Twitter');
        $twitter->get( '/register'         )->to(action => 'register');
        $twitter->get( '/callback-register')->to(action => 'callback_register');
        $twitter->get( '/regist'           )->to(action => 'regist');
        $twitter->get( '/session'          )->to(action => 'action_session');
        $twitter->get( '/callback-session' )->to(action => 'callback_session');
        $twitter->get( '/login'            )->to(action => 'login');
      }
    }

  }

  sub startup($self) {
    $self->load_and_set_up_plugins;
    $self->regist_helpes;
    $self->routing;
  }

}

1;
