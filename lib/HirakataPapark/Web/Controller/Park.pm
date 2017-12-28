package HirakataPapark::Web::Controller::Park {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;

  use Option;
  use Mojo::JSON qw( encode_json );
  use HirakataPapark::Service::User::ShowParkUser;
  use HirakataPapark::Service::Park::Park;
  use HirakataPapark::Model::Parks::Stars;
  use HirakataPapark::Model::Parks::Tags;
  use HirakataPapark::Model::Parks::Images;
  use HirakataPapark::Model::Parks::Comments;
  use HirakataPapark::Model::MultilingualDelegator::Parks::Parks;
  use HirakataPapark::Model::MultilingualDelegator::Parks::Plants;
  use HirakataPapark::Model::MultilingualDelegator::Parks::Equipments;
  use HirakataPapark::Model::MultilingualDelegator::Parks::SurroundingFacilities;

  use constant DEFAULT_COMMENT_NUM => 5;

  has 'park_id' => sub ($self) { $self->param('park_id') };

  has 'parks' => sub ($self) {
    HirakataPapark::Model::MultilingualDelegator::Parks::Parks
      ->new(db => $self->db)
      ->model( $self->lang );
  };

  has 'park_tags' => sub ($self) { HirakataPapark::Model::Parks::Tags->new(db => $self->db) };

  has 'park_stars' => sub ($self) { HirakataPapark::Model::Parks::Stars->new(db => $self->db) };

  has 'park_plants' => sub ($self) {
    HirakataPapark::Model::MultilingualDelegator::Parks::Plants
      ->new(db => $self->db)
      ->model( $self->lang );
  };

  has 'park_equipments' => sub ($self) {
    HirakataPapark::Model::MultilingualDelegator::Parks::Equipments
      ->new(db => $self->db)
      ->model( $self->lang );
  };

  has 'park_facilities' => sub ($self) {
    HirakataPapark::Model::MultilingualDelegator::Parks::SurroundingFacilities
      ->new(db => $self->db)
      ->model( $self->lang );
  };

  has 'park_comments' => sub ($self) {
    HirakataPapark::Model::Parks::Comments->new(db => $self->db)
  };

  has 'park_images' => sub ($self) {
    HirakataPapark::Model::Parks::Images->new(db => $self->db);
  };

  sub show_park_by_id($self) {
    $self->parks->get_row_by_id($self->park_id)->match(
      Some => sub ($row) {
        my $park = HirakataPapark::Service::Park::Park->new({
          row             => $row,
          park_tags       => $self->park_tags,
          park_stars      => $self->park_stars,
          park_plants     => $self->park_plants,
          park_images     => $self->park_images,
          park_equipments => $self->park_equipments,
          park_facilities => $self->park_facilities,
        });
        my $base = $self->url_for('/images/parks');
        $self->stash(
          park       => $park,
          images_json => encode_json( [ map {
            $_->{imageUrl} = $base . '/' . $park->id . '/' . $_->{imageUrl};
            $_;
          } $park->images->to_hash_for_vue_images->@* ]),
          maybe_user => $self->maybe_user->map(sub ($user) {
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
    $self->show_park_by_id;
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

