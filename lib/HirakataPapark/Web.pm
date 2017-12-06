package HirakataPapark::Web {

  use Mojo::Base 'Mojolicious';
  use HirakataPapark;
  use Plack::Session;
  use Plack::Session::Store::File;
  use Plack::Session::State::Cookie;

  use constant SESSION_EXPIRES_TIME => 60 * 60 * 24;

  sub load_and_set_up_plugins($self) {
    $self->plugin(Config => { file => "etc/config/$_.conf" }) for qw( site plugin hypnotoad );
    $self->plugin(AssetPack => { pipes => [qw/Css Sass/] });
    $self->asset->process('base.css' => 'scss/base.scss');
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
    # 汚いやり方なので, いい方法を見つけられればそれに変える
    $self->helper('reply.not_found' => sub ($c) {
      my $url = $c->req->url->path->to_string();
      my $lang = do {
        my $lang = (split q!/!, $url)[1];
        exists HirakataPapark->LANG_TABLE->{$lang} ? $lang : HirakataPapark->DEFAULT_LANG;
      };
      Mojolicious::Plugin::DefaultHelpers::_development("not_found_${lang}", $c);
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
      my $authed_user = $root->under('/user')->to(controller => 'AuthedUser')->to(action => 'auth');
      $authed_user->get('/mypage')->to(action => 'mypage');
    }

  }

  sub startup($self) {
    $self->load_and_set_up_plugins;
    $self->regist_helpes;
    $self->routing;
  }

}

1;
