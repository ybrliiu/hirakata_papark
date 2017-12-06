package HirakataPapark::Web::Controller::AuthedUser {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use Option;
  use HirakataPapark::Exception;
  use HirakataPapark::Validator::Params;
  use HirakataPapark::Model::Parks::Stars;
  use HirakataPapark::Service::User::ParkStar::ParkStar;
  
  has 'user' => sub ($self) { $self->maybe_user->get };

  has 'park_stars' => sub { HirakataPapark::Model::Parks::Stars->new };

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
    $self->render(json => +{ $self->user->%* });
  }

  sub add_park_star($self) {
    my $json = $self->park_star_service->add_star->match(
      Right => sub { { is_success => 1 } },
      Left => sub ($e) {
        if ( $e->isa('HirakataPapark::Validator') ) {
          +{ is_success => 0, errors => $e->errors_and_messages };
        } else {
          HirakataPapark::Exception->throw($e);
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
          +{ is_success => 0, errors => $e->errors_and_messages };
        } else {
          HirakataPapark::Exception->throw($e);
        }
      },
    );
    $self->render(json => $json);
  }

}

1;

