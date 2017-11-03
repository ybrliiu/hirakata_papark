package HirakataPapark::Web::Controller {

  use Mojo::Base 'Mojolicious::Controller';
  use HirakataPapark;

  use Mojo::Util;

  use constant DEFAULT_LANG => 'ja';

  my %LANG_LIST = (
    ja => 1,
    en => 1,
  );

  sub lang {
    my $self = shift;
    $LANG_LIST{ $self->param('lang') } ? $self->param('lang') : DEFAULT_LANG;
  }

  sub render_to_multiple_lang {
    my $self = shift;

    my ($template, $args) = (@_ % 2 ? shift : undef, {@_});
    $args->{template} = $template if $template;
    $args->{template} //= do {
      my $defaults = $self->match->endpoint->pattern->defaults;
      Mojo::Util::decamelize($self->stash->{controller}) . '/' . $self->stash->{action};
    };
    $args->{template} .= '_' . $self->lang;
    $args->{lang} = $self->lang;

    $self->render(%$args);
  }

  # override
  sub render {
    my $self = shift;
    $self->SUPER::render(@_, JS_FILES => [], SCSS_FILES => [], CSS_FILES => []);
  }

}

1;

