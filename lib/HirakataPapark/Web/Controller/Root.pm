package HirakataPapark::Web::Controller::Root {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;

  has 'parks' => sub ($self) {
    $self->model('HirakataPapark::Model::MultilingualDelegator::Parks::Parks')
      ->model($self->lang);
  };

  sub top($self) {
    $self->redirect_to('/ja/');
  }

  sub root($self) {
    my $parks = $self->parks->get_rows_all;
    my $parks_json = $parks->to_json_for_marker;
    $self->stash(parks_json => $parks_json);
    $self->render;
  }

  sub current_location($self) {
    $self->root;
  }

  sub about($self) {
    $self->render_to_multiple_lang;
  }

}

1;
