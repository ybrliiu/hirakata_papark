package HirakataPapark::Web::Controller {

  use Mojo::Base 'Mojolicious::Controller';
  use HirakataPapark;
  use Option;
  use Mojo::Util;
  use HirakataPapark::Model::Users::Users;
  use HirakataPapark::Class::LangDict::MultilingualDelegator;

  use constant NOT_FOUND => 404;

  has 'lang' => sub ($self) {
    my $lang = $self->param('lang');
    exists HirakataPapark->LANG_TABLE->{$lang} ? $lang : HirakataPapark->DEFAULT_LANG;
  };

  has 'users' => sub { HirakataPapark::Model::Users::Users->new };

  has 'maybe_user_seacret_id' => sub ($self) {
    option( $self->plack_session->get('user.seacret_id') );
  };

  has 'maybe_user' => sub ($self) {
    $self->maybe_user_seacret_id->flat_map(sub ($id) {
      $self->users->get_row_by_seacret_id($id)->map(sub ($user) { $user });
    });
  };

  has 'lang_dict' => sub ($self) {
    HirakataPapark::Class::LangDict::MultilingualDelegator->instance->lang_dict($self->lang)
  };

  sub render_to_multiple_lang {
    my $self = shift;

    my ($template, $args) = (@_ % 2 ? shift : undef, {@_});
    $args->{template} = $template if $template;
    $args->{template} //= $self->app->renderer->template_for($self);
    $args->{template} .= '_' . $self->lang;
    $args->{lang} = $self->lang;

    $self->render(%$args);
  }

  # override
  sub render {
    my $self = shift;
    $self->stash(lang_dict => $self->lang_dict);
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

