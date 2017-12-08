package HirakataPapark::Web::Controller::Search {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;

  use HirakataPapark::Class::Coord;
  use HirakataPapark::Model::Parks::Tags;
  use HirakataPapark::Model::MultilingualDelegator::Parks::Parks;
  use HirakataPapark::Model::MultilingualDelegator::Parks::Plants;
  use HirakataPapark::Model::MultilingualDelegator::Parks::Equipments;
  use HirakataPapark::Model::MultilingualDelegator::Parks::SurroundingFacilities;
  use HirakataPapark::Service::Park::CalcDistance;

  has 'park_tags' => sub { HirakataPapark::Model::Parks::Tags->new };

  has 'parks' => sub ($self) {
    HirakataPapark::Model::MultilingualDelegator::Parks::Parks->new->model( $self->lang );
  };

  has 'park_plants' => sub ($self) {
    HirakataPapark::Model::MultilingualDelegator::Parks::Plants->new->model( $self->lang );
  };

  has 'park_equipments' => sub ($self) {
    HirakataPapark::Model::MultilingualDelegator::Parks::Equipments->new->model( $self->lang );
  };

  has 'park_surrounding_facilities' => sub ($self) {
    HirakataPapark::Model::MultilingualDelegator::Parks::SurroundingFacilities->new
      ->model( $self->lang );
  };

  sub near_parks($self) {
    my $point = HirakataPapark::Class::Coord->new(
      x => $self->param('x'),
      y => $self->param('y'),
    );
    my $distance = $self->param('distance');
    my $parks = $self->parks->get_rows_all();
    my @result = grep {
      my $park = $_;
      my $calculator = HirakataPapark::Service::Park::CalcDistance->new(
        coord1 => $point,
        coord2 => $park,
      );
      $calculator->calc() <= $distance;
    } @$parks;
    $self->stash(parks => \@result);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub like_name($self) {
    my $park_name = $self->param('park_name');
    my $parks     = $self->parks->get_rows_like_name($park_name);
    $self->stash(parks => $parks);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub like_address($self) {
    my $park_address = $self->param('park_address');
    my $parks        = $self->parks->get_rows_like_address($park_address);
    $self->stash(parks => $parks);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub by_equipments($self) {
    my $equipments = $self->every_param('equipments');
    my $parks      = $self->parks->get_by_equipments($equipments);
    $self->stash(parks => $parks);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub has_tags($self) {
    my $tags    = $self->every_param('tags');
    my $id_list = $self->park_tags->get_park_id_list_has_names($tags);
    my $parks   = $self->parks->get_rows_by_id_list($id_list);
    $self->stash(parks => $parks);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub has_plants($self) {
    my $plants  = $self->every_param('plants');
    my $id_list = $self->park_plants->get_park_id_list_has_names($plants);
    my $parks   = $self->parks->get_rows_by_id_list($id_list);
    $self->stash(parks => $parks);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub has_plants_categories($self) {
    my $categories  = $self->every_param('plants_categories');
    my $park_plants = $self->park_plants;
    my $id_list     = $park_plants->get_park_id_list_has_category_names($categories);
    my $parks       = $self->parks->get_rows_by_id_list($id_list);
    $self->stash(parks => $parks);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub has_equipments($self) {
    my $equipments = $self->every_param('equipments');
    my $id_list    = $self->park_equipments->get_park_id_list_has_names($equipments);
    my $parks      = $self->parks->get_rows_by_id_list($id_list);
    $self->stash(parks => $parks);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub has_surrounding_facilities($self) {
    my $sf      = $self->every_param('surrounding_facilities');
    my $id_list = $self->park_surrounding_facilities->get_park_id_list_has_names($sf);
    my $parks   = $self->parks->get_rows_by_id_list($id_list);
    $self->stash(parks => $parks);
    $self->render_to_multiple_lang(template => 'search/result');
  }

}

1;

