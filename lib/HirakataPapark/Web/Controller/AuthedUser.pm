package HirakataPapark::Web::Controller::AuthedUser {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use Option;
  use HirakataPapark::Exception;
  use HirakataPapark::Validator::Params;
  use HirakataPapark::Model::Parks::Tags;
  use HirakataPapark::Model::Parks::Stars;
  use HirakataPapark::Service::User::ParkStar::ParkStar;
  use HirakataPapark::Service::User::ParkTagger::ParkTagger;
  
  has 'user' => sub ($self) { $self->maybe_user->get };

  has 'park_stars' => sub { HirakataPapark::Model::Parks::Stars->new };

  has 'park_tags' => sub { HirakataPapark::Model::Parks::Tags->new };

  has 'park_star_service' => sub ($self) {
    HirakataPapark::Service::User::ParkStar::ParkStar->new({
      db         => $self->park_stars->db,
      lang       => $self->lang,
      user       => $self->user,
      params     => HirakataPapark::Validator::Params->new({ park_id => $self->param('park_id') }),
      park_stars => $self->park_stars,
    });
  };

  sub auth($self) {
    $self->maybe_user_id->fold(sub {
      $self->render(states => 401, text => 'Unauthorized');
      0;
    })->(sub ($id) { 1 });
  }

  sub mypage($self) {
    $self->stash(user => $self->user);
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
      validator => "HirakataPapark::Service::User::ParkTagger::Validator",
    });
    $self->render_to_multiple_lang;
  }

  sub add_park_tag($self) {
    my $service = HirakataPapark::Service::User::ParkTagger::ParkTagger->new({
      db         => $self->park_tags->db,
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

}

1;

