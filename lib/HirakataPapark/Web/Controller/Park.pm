package HirakataPapark::Web::Controller::Park {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use Option;
  use HirakataPapark::Service::User::ShowParkUser;
  use HirakataPapark::Service::Park::Park;

  use constant DEFAULT_COMMENT_NUM => 5;

  has 'park_id' => sub ($self) { $self->param('park_id') };

  {
    my %accessors = (
      parks           => 'HirakataPapark::Model::MultilingualDelegator::Parks::Parks',
      park_plants     => 'HirakataPapark::Model::MultilingualDelegator::Parks::Plants',
      park_equipments => 'HirakataPapark::Model::MultilingualDelegator::Parks::Equipments',
      park_facilities =>
        'HirakataPapark::Model::MultilingualDelegator::Parks::SurroundingFacilities',
    );
  
    while ( my ($accessor_name, $model_name) = each %accessors ) {
      has $accessor_name =>
        sub ($self) { $self->model($model_name)->model($self->lang) };
    }
  }

  {
    my %accessors = (
      park_tags     => 'HirakataPapark::Model::Parks::Tags',
      park_stars    => 'HirakataPapark::Model::Parks::Stars',
      park_images   => 'HirakataPapark::Model::Parks::Images',
      park_comments => 'HirakataPapark::Model::Parks::Comments',
    );

    while ( my ($accessor_name, $model_name) = each %accessors ) {
      has $accessor_name =>
        sub ($self) { $self->model($model_name) };
    }
  }

  sub create_extend_park($self, $row) {
    HirakataPapark::Service::Park::Park->new({
      row                          => $row,
      static_path                  => $self->url_for('/')->to_abs->to_string,
      tags_model                   => $self->park_tags,
      stars_model                  => $self->park_stars,
      plants_model                 => $self->park_plants,
      images_model                 => $self->park_images,
      equipments_model             => $self->park_equipments,
      surrounding_facilities_model => $self->park_facilities,
    });
  }

  sub show_park_by_id($self) {
    $self->parks->get_row_by_id($self->park_id)->match(
      Some => sub ($row) {
        my $park = $self->create_extend_park($row);
        $self->stash(
          park        => $park,
          maybe_user  => $self->maybe_user->map(sub ($user) {
            HirakataPapark::Service::User::ShowParkUser->new({
              row        => $user,
              park_stars => $self->park_stars,
            });
          }),
        );
        $self->render_to_multiple_lang;
      },
      None => sub { $self->render_not_found },
    );
  }

  sub show_park_plants_by_id($self) {
    $self->parks->get_row_by_id($self->park_id)->match(
      Some => sub ($row) {
        my $park = $self->create_extend_park($row);
        $self->stash(park => $park),
        $self->render;
      },
      None => sub { $self->render_not_found },
    );
  }

  sub add_comment_by_id($self) {
    $self->park_comments->add_row({
      park_id => $self->park_id,
      name    => $self->param('name') || '名無し',
      message => $self->param('message'),
    });
    $self->render(text => 'add comment success');
  }

  sub get_comments_by_id($self) {
    my $comments = $self->park_comments
      ->get_rows_by_park_id($self->park_id, DEFAULT_COMMENT_NUM);
    $self->render(comments => $comments);
  }

}

1;

