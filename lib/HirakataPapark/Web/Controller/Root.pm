package HirakataPapark::Web::Controller::Root {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;

  use HirakataPapark::Model::Parks::Parks;

  has 'parks' => sub { HirakataPapark::Model::Parks::Parks->new };

  sub top($self) {
    $self->redirect_to('/ja/');
  }

  sub root($self) {
    my $parks = $self->parks->get_rows_all;
    my $parks_json = $self->lang eq 'en'
      ? $parks->to_english_json_for_marker
      : $parks->to_json_for_marker;
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
