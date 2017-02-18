package HirakataPapark::Web::Controller {

  use Mojo::Base 'Mojolicious::Controller';
  use HirakataPapark;

  # override
  sub render {
    my $self = shift;
    $self->SUPER::render(@_, JS_FILES => [], SCSS_FILES => []);
  }

}

1;

