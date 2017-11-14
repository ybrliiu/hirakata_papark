package HirakataPapark::Web::Controller::Search {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use HirakataPapark::Class::Point;
  use HirakataPapark::Model::Parks;
  use HirakataPapark::Service::Search;
  use HirakataPapark::Service::Park::CalcDistance;

  has 'parks' => sub { HirakataPapark::Model::Parks->new };

  has 'service' => sub { HirakataPapark::Service::Search->new };

  sub near_parks($self) {
    my $point = HirakataPapark::Class::Point->new(
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
      my $ans = $calculator->calc();
      $ans <= $distance;
    } @$parks;
    $self->stash(parks => \@result);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub like_name {
    my $self = shift;
    my $park_name = $self->param('park_name');
    my $result = $self->lang eq 'en'
      ? $self->service->like_english_name($park_name)
      : $self->service->like_name($park_name);
    $self->stash($result);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub like_address {
    my $self = shift;
    my $park_address = $self->param('park_address');
    my $result = $self->lang eq 'en'
      ? $self->service->like_english_address($park_address)
      : $self->service->like_address($park_address);
    $self->stash($result);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub by_equipments {
    my $self = shift;
    my $equipments = $self->every_param('equipments');
    my $result = $self->lang eq 'en'
      ? $self->service->by_equipments_english($equipments)
      : $self->service->by_equipments($equipments);
    $self->stash($result);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub has_tags {
    my $self = shift;
    my $result = $self->service->has_tags( $self->every_param('tags') );
    $self->stash($result);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub has_plants {
    my $self = shift;
    my $plants = $self->every_param('plants');
    my $result = $self->lang eq 'en'
      ? $self->service->has_plants_english($plants)
      : $self->service->has_plants($plants);
    $self->stash($result);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub has_plants_categories {
    my $self = shift;
    my $categories = $self->every_param('plants_categories');
    my $result = $self->lang eq 'en'
      ? $self->service->has_plants_categories_english($categories)
      : $self->service->has_plants_categories($categories);
    $self->stash($result);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub has_equipments {
    my $self = shift;
    my $equipments = $self->every_param('equipments');
    my $result = $self->lang eq 'en'
      ? $self->service->has_equipments_english($equipments)
      : $self->service->has_equipments($equipments);
    $self->stash($result);
    $self->render_to_multiple_lang(template => 'search/result');
  }

  sub has_surrounding_facilities {
    my $self = shift;
    my $surrounding_facilities = $self->every_param('surrounding_facilities');
    my $result = $self->lang eq 'en'
      ? $self->service->has_surrounding_facilities_english($surrounding_facilities)
      : $self->service->has_surrounding_facilities($surrounding_facilities);
    $self->stash($result);
    $self->render_to_multiple_lang(template => 'search/result');
  }

}

1;

