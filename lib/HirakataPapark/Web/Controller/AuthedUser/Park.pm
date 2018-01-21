package HirakataPapark::Web::Controller::AuthedUser::Park {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use Option;
  use HirakataPapark::Validator::Params;
  use HirakataPapark::Service::User::Park::StarHandler::Handler;
  use HirakataPapark::Service::User::Park::Tagger::Tagger;
  use HirakataPapark::Service::User::Park::ImagePoster::Poster;
  use HirakataPapark::Service::User::Park::Editer::Editer;
  use aliased 'HirakataPapark::Service::User::Park::Editer::MessageData' =>
    'EditerMessageData';
  
  has 'user' => sub ($self) { $self->maybe_user->get };

  has 'parks_model' => sub ($self) {
    $self->model('HirakataPapark::Model::MultilingualDelegator::Parks::Parks')
      ->model($self->lang);
  };

  my %accessors = (
    tags_model   => 'HirakataPapark::Model::Parks::Tags',
    stars_model  => 'HirakataPapark::Model::Parks::Stars',
    images_model => 'HirakataPapark::Model::Parks::Images',
  );

  while ( my ($accessor_name, $model_name) = each %accessors ) {
    has $accessor_name => sub ($self) { $self->model($model_name) };
  }

  has 'star_handler' => sub ($self) {
    HirakataPapark::Service::User::Park::StarHandler::Handler->new({
      db     => $self->db,
      lang   => $self->lang,
      user   => $self->user,
      params => HirakataPapark::Validator::Params->new({
        park_id => $self->param('park_id'),
      }),
      park_stars => $self->stars_model,
    });
  };

  sub add_star($self) {
    my $json = $self->star_handler->add_star->match(
      Right => sub { { is_success => 1 } },
      Left => sub ($e) {
        if ( $e->isa('HirakataPapark::Validator::Core') ) {
          +{ is_success => 0, errors => $e->errors_and_messages };
        } else {
          die $e;
        }
      },
    );
    $self->render(json => $json);
  }

  sub remove_star($self) {
    my $json = $self->star_handler->remove_star->match(
      Right => sub { { is_success => 1 } },
      Left => sub ($e) {
        if ( $e->isa('HirakataPapark::Validator::Core') ) {
          { is_success => 0, errors => $e->errors_and_messages };
        } else {
          die $e;
        }
      },
    );
    $self->render(json => $json);
  }

  sub tagger($self) {
    my $park_id = $self->param('park_id');
    $self->stash({
      park_id   => $park_id,
      tag_list  => $self->tags_model->get_rows_by_park_id($park_id),
      validator => "HirakataPapark::Service::User::Park::Tagger::Validator",
    });
    $self->render;
  }

  sub add_tag($self) {
    my $service = HirakataPapark::Service::User::Park::Tagger::Tagger->new({
      db        => $self->db,
      lang      => $self->lang,
      params    => HirakataPapark::Validator::Params->new({
        map { $_ => $self->param($_) } qw( park_id tag_name )
      }),
      park_tags => $self->tags_model,
    });
    my $json = $service->add_tag->match(
      Right => sub {
        +{
          is_success => 1,
          redirect_to => $self->url_for("/@{[ $self->lang ]}/park/@{[ $self->param('park_id') ]}"),
        }
      },
      Left => sub ($e) {
        if ( $e->isa('HirakataPapark::Validator::Core') ) {
          +{ is_success => 0, errors => $e->errors_and_messages };
        } else {
          die $e;
        }
      },
    );
    $self->render(json => $json);
  }

  sub image_poster($self) {
    my $message_data = HirakataPapark::Service::User::Park::ImagePoster::MessageData
      ->instance->message_data($self->lang);
    $self->stash({
      park_id      => $self->param('park_id'),
      validator    => 'HirakataPapark::Service::User::Park::ImagePoster::Validator',
      message_data => $message_data,
    });
    $self->render;
  }

  sub post_image($self) {
    my $poster = HirakataPapark::Service::User::Park::ImagePoster::Poster->new({
      db     => $self->db,
      lang   => 'ja',
      user   => $self->user,
      params => HirakataPapark::Validator::Params->new({
        map { $_ => $self->param($_) } qw( park_id title image_file )
      }),
      park_images => $self->images_model,
    });
    my $json = $poster->post->match(
      Right => sub ($params) {
        my $url = $self->url_for( '/' . $self->lang . '/park/' . $self->param('park_id') );
        +{ is_success  => 1, redirect_to => $url };
      },
      Left => sub ($e) {
        if ( $e->isa('HirakataPapark::Validator::Core') ) {
          +{ is_success => 0, errors => $e->errors_and_messages };
        } else {
          die $e;
        }
      },
    );
    $self->render(json => $json);
  }

  sub editer($self) {
    my $park_id   = $self->param('park_id');
    $self->parks_model->get_row_by_id($park_id)->match(
      Some => sub ($park) {
        my $lang_dict = EditerMessageData->instance->message_data($self->lang);
        $self->stash({
          park      => $park,
          lang_dict => $lang_dict,
        });
        $self->render;
      },
      None => sub { $self->render_not_found },
    );
  }

}

1;

