package HirakataPapark::Web::Controller::Searcher {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use HirakataPapark::Service::Searcher;

  has 'service' => sub { HirakataPapark::Service::Searcher->new };

  sub root($self) {
    $self->render_to_multiple_lang();
  }

  sub name($self) {
    $self->render_to_multiple_lang();
  }

  sub address($self) {
    $self->render_to_multiple_lang();
  }

  # Mojolicious::Plugin::AssetPack で tag というメソッド(helper?)が登録されているため,
  # Controllerでtag というmethodが定義できない
  sub tags($self) {
    my $result = $self->service->tag;
    $self->stash($result);
    $self->render_to_multiple_lang(template => 'searcher/tag');
  }

  sub plants($self) {
    my $result = $self->service->plants;
    $self->stash($result);
    $self->render_to_multiple_lang();
  }

  sub equipment($self) {
    my $result = $self->service->equipment;
    $self->stash($result);
    $self->render_to_multiple_lang();
  }

  sub surrounding_facility($self) {
    my $result = $self->service->surrounding_facility;
    $self->stash($result);
    $self->render_to_multiple_lang();
  }

}

1;

