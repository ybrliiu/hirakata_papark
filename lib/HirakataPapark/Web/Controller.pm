package HirakataPapark::Web::Controller {

  use Mojo::Base 'Mojolicious::Controller';
  use HirakataPapark;
  use Option;
  use Mojo::Util;
  use HirakataPapark::Model::Users::Users;

  use constant NOT_FOUND => 404;

  has 'lang' => sub ($self) {
    my $lang = $self->param('lang');
    exists HirakataPapark->LANG_TABLE->{$lang} ? $lang : HirakataPapark->DEFAULT_LANG;
  };

  has 'users' => sub { HirakataPapark::Model::Users::Users->new };

  has 'maybe_user_id' => sub ($self) {
    option( $self->plack_session->get('user.id') );
  };

  has 'maybe_user' => sub ($self) {
    $self->maybe_user_id->flat_map(sub ($id) {
      $self->users->get_row_by_id($id)->map(sub ($user) { $user });
    });
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
    $self->stash(maybe_user => $self->maybe_user) unless $self->stash('maybe_user');
    $self->SUPER::render(@_, CSS_FILES => []);
  }

  sub render_not_found($self) {
    my $template = 'not_found_'. $self->lang;
    $self->render_maybe(
      template => $template,
      format   => 'html',
      status   => NOT_FOUND,
    );
  }

}

1;

