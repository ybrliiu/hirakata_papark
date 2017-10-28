package HirakataPapark::Web::Controller::Root {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use HirakataPapark::Service::Root;

  has 'service' => sub { HirakataPapark::Service::Root->new };

  sub top {
    my $self = shift;
    $self->redirect_to('/ja/');
  }

  sub root {
    my $self = shift;
    $self->stash( $self->lang eq 'en' ? $self->service->root_en : $self->service->root_ja );
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
