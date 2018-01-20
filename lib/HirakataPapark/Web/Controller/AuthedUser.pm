package HirakataPapark::Web::Controller::AuthedUser {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use Option;
  use HirakataPapark::Validator::Params;
  use HirakataPapark::Service::User::MyPage::User;
  use HirakataPapark::Service::User::Park::StarHandler::Handler;
  use HirakataPapark::Service::User::Park::Tagger::Tagger;
  use HirakataPapark::Service::User::Park::ImagePoster::Poster;
  
  has 'user' => sub ($self) { $self->maybe_user->get };

  has 'parks_model' => sub ($self) {
    $self->model('HirakataPapark::Model::MultilingualDelegator::Parks::Parks')
      ->model($self->lang);
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
      parks => $self->parks_model,
    });
    $self->stash(user => $user);
    $self->render_to_multiple_lang;
  }

}

1;

