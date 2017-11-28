package HirakataPapark::Web::Controller::Search {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;

  use HirakataPapark::Class::Coord;
  use HirakataPapark::Model::Parks::Parks;
  use HirakataPapark::Model::Parks::Parks::Tags;
  use HirakataPapark::Model::Parks::Parks::Plants;
  use HirakataPapark::Model::Parks::Parks::Equipments;
  use HirakataPapark::Model::Parks::Parks::SurroundingFacilities;
  use HirakataPapark::Service::Park::CalcDistance;

  has 'parks'           => sub { HirakataPapark::Model::Parks::Parks->new };
  has 'park_tags'       => sub { HirakataPapark::Model::Parks::Parks::Tags->new };
  has 'park_plants'     => sub { HirakataPapark::Model::Parks::Parks::Plants->new };
  has 'park_equipments' => sub { HirakataPapark::Model::Parks::Parks::Equipments->new };
  has 'park_surrounding_facilities' =>
    sub { HirakataPapark::Model::Parks::Parks::SurroundingFacilities->new };

  sub near_parks {
    my $self = shift;
    my $point = HirakataPapark::Class::Coord->new(
      x => $self->param('x'),
      y => $self->param('y'),
    );
    my $distance = $self->param('distance');
    my $parks = $self->parks->get_rows_all();
    my @result = grep {
      my $park = $_;
      my $calculator = HirakataPapark::Service::Park::CalcDistance->new(
        point1 => $point,
        point2 => $park,
      );
      $calculator->calc() <= $distance;
    } @$parks;
    $self->stash(parks => \@result);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub like_name {
    my $self = shift;
    my $park_name = $self->param('park_name');
    my $parks = $self->lang eq 'en'
      ? $self->parks->get_rows_like_english_name($park_name)
      : $self->parks->get_rows_like_name($park_name);
    $self->stash(parks => $parks);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub like_address {
    my $self = shift;
    my $park_address = $self->param('park_address');
    my $parks = $self->lang eq 'en'
      ? $self->parks->get_rows_like_english_address($park_address)
      : $self->parks->get_rows_like_address($park_address);
    $self->stash(parks => $parks);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub by_equipments {
    my $self = shift;
    my $equipments = $self->every_param('equipments');
    my $parks = $self->lang eq 'en'
      ? $self->parks->by_equipments_english($equipments)
      : $self->parks->by_equipments($equipments);
    $self->stash(parks => $parks);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub has_tags {
    my $self = shift;
    my $tags    = $self->every_param('tags');
    my $id_list = $self->park_tags->get_park_id_list_has_names($tags);
    my $parks   = $self->parks->get_rows_by_id_list($id_list);
    $self->stash(parks => $parks);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub has_plants {
    my $self = shift;
    my $plants  = $self->every_param('plants');
    my $id_list = $self->lang eq 'en'
      ? $self->park_plants->get_park_id_list_has_english_names($plants)
      : $self->park_plants->get_park_id_list_has_names($plants);
    my $parks = $self->parks->get_rows_by_id_list($id_list);
    $self->stash(parks => $parks);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub has_plants_categories {
    my $self = shift;
    my $categories  = $self->every_param('plants_categories');
    my $park_plants = $self->park_plants;
    my $id_list = $self->lang eq 'en'
      ? $park_plants->get_park_id_list_has_english_category_names($categories)
      : $park_plants->get_park_id_list_has_category_names($categories);
    my $parks = $self->parks->get_rows_by_id_list($id_list);
    $self->stash(parks => $parks);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub has_equipments {
    my $self = shift;
    my $equipments = $self->every_param('equipments');
    my $id_list = $self->lang eq 'en'
      ? $self->park_equipments->get_park_id_list_has_english_names($equipments)
      : $self->park_equipments->get_park_id_list_has_names($equipments);
    my $parks = $self->parks->get_rows_by_id_list($id_list);
    $self->stash(parks => $parks);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub has_surrounding_facilities {
    my $self = shift;
    my $sf      = $self->every_param('surrounding_facilities');
    my $id_list = $self->lang eq 'en'
      ? $self->park_surrounding_facilities->get_park_id_list_has_english_names($sf)
      : $self->park_surrounding_facilities->get_park_id_list_has_names($sf);
    my $parks = $self->parks->get_rows_by_id_list($id_list);
    $self->stash(parks => $parks);
    $self->render_to_multiple_lang(template => 'search/result');
  }

}

1;

