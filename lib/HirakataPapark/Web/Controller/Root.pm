package HirakataPapark::Web::Controller::Root {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use HirakataPapark::Model::MultilingualDelegator::Parks::Parks;

  has 'parks' => sub ($self) {
    HirakataPapark::Model::MultilingualDelegator::Parks::Parks
      ->new(db => $self->db)
      ->model($self->lang);
  };

  sub top($self) {
    $self->redirect_to('/ja/');
  }

  sub root($self) {
    my $parks = $self->parks->get_rows_all;
    my $parks_json = $parks->to_json_for_marker;
    $self->stash(parks_json => $parks_json);
    $self->render_to_multiple_lang;
  }

  sub current_location($self) {
    $self->root;
  }

  sub about($self) {
    $self->render_to_multiple_lang;
  }

}

1;
