package HirakataPapark::Web::Controller::AuthedUser {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use Option;
  use HirakataPapark::Exception;
  use HirakataPapark::Model::Parks::Stars;
  
  has 'user' => sub ($self) { $self->maybe_user->get };

  has 'park_stars' => sub { HirakataPapark::Model::Parks::Stars->new };

  sub auth($self) {
    $self->maybe_user_id->fold(sub {
      $self->render(states => 401, text => 'Unauthorized');
      0;
    })->(sub ($id) { 1 });
  }

  sub mypage($self) {
    $self->render(json => +{ $self->user->%* });
  }

  sub add_star($self) {
    my $service = HirakataPapark::Service::User::AddParkStar::AddParkStar->new({
      db         => $self->park_stars->db,
      park_stars => $self->park_stars,
      user       => $self->user,
      park_id    => option( $self->param('park_id') )->get_or_else(''),
    });
    my $json = $service->add_star->match(
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

