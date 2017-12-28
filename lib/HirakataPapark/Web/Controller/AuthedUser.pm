package HirakataPapark::Web::Controller::AuthedUser {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use Option;
  use HirakataPapark::Exception;
  use HirakataPapark::Validator::Params;
  use HirakataPapark::Model::Parks::Tags;
  use HirakataPapark::Model::Parks::Stars;
  use HirakataPapark::Model::Parks::Images;
  use HirakataPapark::Model::MultilingualDelegator::Parks::Parks;
  use HirakataPapark::Service::User::MyPage::User;
  use HirakataPapark::Service::User::Park::StarHandler::Handler;
  use HirakataPapark::Service::User::Park::Tagger::Tagger;
  use HirakataPapark::Service::User::Park::ImagePoster::Poster;
  
  has 'user' => sub ($self) { $self->maybe_user->get };

  has 'parks' => sub ($self) {
    HirakataPapark::Model::MultilingualDelegator::Parks::Parks
      ->new(db => $self->db)
      ->model($self->lang);
  };

  has 'park_tags' => sub ($self) {
    HirakataPapark::Model::Parks::Tags->new(db => $self->db)
  };

  has 'park_stars' => sub ($self) {
    HirakataPapark::Model::Parks::Stars->new(db => $self->db)
  };

  has 'park_image_poster' => sub ($self) {
    HirakataPapark::Model::Parks::Images->new(db => $self->db);
  };

  has 'park_star_service' => sub ($self) {
    HirakataPapark::Service::User::Park::StarHandler::Handler->new({
      db     => $self->db,
      lang   => $self->lang,
      user   => $self->user,
      params => HirakataPapark::Validator::Params->new({
        park_id => $self->param('park_id'),
      }),
      park_stars => $self->park_stars,
    });
  };

  sub auth($self) {
    $self->maybe_user_seacret_id->fold(sub {
      $self->render(states => 401, text => 'Unauthorized');
      0;
    })->(sub ($id) { 1 });
  }

  sub mypage($self) {
    my $user = HirakataPapark::Service::User::MyPage::User->new({
      row   => $self->user,
      parks => $self->parks,
    });
    $self->stash(user => $user);
    $self->render_to_multiple_lang;
  }

  sub add_park_star($self) {
    my $json = $self->park_star_service->add_star->match(
      Right => sub { { is_success => 1 } },
      Left => sub ($e) {
        if ( $e->isa('HirakataPapark::Validator') ) {
          +{ is_success => 0, errors => $e->errors_and_messages };
        } else {
          die $e;
        }
      },
    );
    $self->render(json => $json);
  }

  sub remove_park_star($self) {
    my $json = $self->park_star_service->remove_star->match(
      Right => sub { { is_success => 1 } },
      Left => sub ($e) {
        if ( $e->isa('HirakataPapark::Validator') ) {
          { is_success => 0, errors => $e->errors_and_messages };
        } else {
          die $e;
        }
      },
    );
    $self->render(json => $json);
  }

  sub park_tagger($self) {
    my $park_id = $self->param('park_id');
    $self->stash({
      park_id   => $park_id,
      tag_list  => $self->park_tags->get_rows_by_park_id($park_id),
      validator => "HirakataPapark::Service::User::Park::Tagger::Validator",
    });
    $self->render_to_multiple_lang;
  }

  sub add_park_tag($self) {
    my $service = HirakataPapark::Service::User::Park::Tagger::Tagger->new({
      db         => $self->db,
      lang       => $self->lang,
      params     => HirakataPapark::Validator::Params->new({
        map { $_ => $self->param($_) } qw( park_id tag_name )
      }),
      park_tags => $self->park_tags,
    });
    my $json = $service->add_tag->match(
      Right => sub {
        {
          is_success => 1,
          redirect_to => $self->url_for("/@{[ $self->lang ]}/park/@{[ $self->param('park_id') ]}"),
        }
      },
      Left => sub ($e) {
        if ( $e->isa('HirakataPapark::Validator') ) {
          { is_success => 0, errors => $e->errors_and_messages };
        } else {
          die $e;
        }
      },
    );
    $self->render(json => $json);
  }

  sub park_editer($self) {
  }

  sub park_image_poster($self) {
    my $message_data = HirakataPapark::Service::User::Regist::MessageData
      ->instance->message_data($self->lang);
    $self->stash(message_data => $message_data);
    $self->render_to_multiple_lang;
  }

  sub post_park_image($self) {
    my $poster = HirakataPapark::Service::User::Park::ImagePoster::Poster->new({
      db     => $db,
      lang   => 'ja',
      user   => $user,
      params => HirakataPapark::Validator::Params->new({
        map { $_ => $self->param($_) } qw( park_id title image_file )
      }),
      park_images => $self->park_images,
    });
    my $json = $poster->post->match(
      Right => sub ($params) {
        +{
          is_success  => 1,
          redirect_to => "/@{[ $self->lang ]}/park/@{[ $params->param('park_id') ]}",
        };
      },
      Left => sub ($e) {
        if ( $e->isa('HirakataPapark::Validator') ) {
          +{ is_success => 0, errors => $e->errors_and_messages };
        } else {
          die $e;
        }
      },
    );
    $self->render(json => $json);
  }

}

1;

