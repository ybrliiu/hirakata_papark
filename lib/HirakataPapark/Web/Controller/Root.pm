package HirakataPapark::Web::Controller::Root {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;

  use HirakataPapark::Model::Parks;

  has 'parks' => sub { HirakataPapark::Model::Parks->new };

  sub top {
    my $self = shift;
    $self->redirect_to('/ja/');
  }

  sub root {
    my $self = shift;
    $self->parks->get_rows_all();
    my $parks_json = $self->lang eq 'en'
      ? $self->parks->to_english_json_for_marker
      : $self->parks->to_json_for_marker;
    $self->stash(parks_json => $parks_json);
    $self->render_to_multiple_lang();
  }

  sub current_location {
    my $self = shift;
    $self->root();
  }

  sub about {
    my $self = shift;
    $self->render_to_multiple_lang();
  }

}

1;
