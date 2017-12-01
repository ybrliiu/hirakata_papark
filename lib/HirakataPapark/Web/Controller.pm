package HirakataPapark::Web::Controller {

  use Mojo::Base 'Mojolicious::Controller';
  use HirakataPapark;

  use Mojo::Util;

  use constant NOT_FOUND => 404;

  has 'lang' => sub {
    my $self = shift;
    my $lang = $self->param('lang');
    exists HirakataPapark->LANG_TABLE->{$lang} ? $lang : HirakataPapark->DEFAULT_LANG;
  };

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

  sub reply_not_found {
    my $self = shift;
    my $template = 'not_found_'. $self->lang;
    $self->render_maybe(
      template => $template,
      format   => 'html',
      status   => NOT_FOUND,
    );
  }

}

1;

