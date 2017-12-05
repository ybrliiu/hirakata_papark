package HirakataPapark::Web::Controller::AuthedUser {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use HirakataPapark::Model::Users::Users;

  has 'users' => sub { HirakataPapark::Model::Users::Users->new };

  has 'user' => sub ($self) {
    my $id = $self->plack_session->get('user.id');
    $self->users->get_row_by_id($id)
      ->fold(sub { $self->render(status => 401, text => 'Unauthorized') })
      ->(sub ($user) { $user });
  };

  sub auth($self) {
    if ( $self->plack_session->get('user.id') ) {
      1;
    } else {
      $self->render(status => 401, text => 'Unauthorized');
      0;
    }
  }

  sub mypage($self) {
    $self->render(json => +{ $self->user->%* });
  }

}

1;
