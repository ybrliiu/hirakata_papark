package HirakataPapark::Web::Controller {

  use Mojo::Base 'Mojolicious::Controller';
  use Option;
  use HirakataPapark;
  use HirakataPapark::Types;
  use HirakataPapark::Container;
  use HirakataPapark::Model::Users::Users;
  use HirakataPapark::Model::MultilingualDelegator::LangDict::Common;

  use constant NOT_FOUND => 404;

  has 'container' => sub ($self) {
    HirakataPapark::Container->instance;
  };

  has 'db' => sub ($self) {
    $self->container->fetch('DB/psql')->get;
  };

  has 'users' => sub ($self) { $self->model('HirakataPapark::Model::Users::Users') };

  has 'lang' => sub ($self) {
    my $lang = $self->param('lang');
    exists HirakataPapark::Types->LANGS_TABLE->{$lang}
      ? $lang : HirakataPapark::Types->DEFAULT_LANG;
  };

  has 'lang_dict' => sub ($self) {
    HirakataPapark::Model::MultilingualDelegator::LangDict::Common
      ->instance->lang_dict($self->lang)
  };

  has 'maybe_user' => sub ($self) {
    $self->maybe_user_seacret_id->flat_map(sub ($id) {
      $self->users->get_row_by_seacret_id($id)->map(sub ($user) { $user });
    });
  };

  has 'maybe_user_seacret_id' => sub ($self) {
    option( $self->plack_session->get('user.seacret_id') );
  };

  sub model($self, $path) {
    $self->container->fetch("Model/$path")->get;
  }

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

