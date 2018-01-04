package HirakataPapark::Web::Controller::Searcher {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;

  use HirakataPapark::Model::Parks::Tags;
  use HirakataPapark::Model::MultilingualDelegator::Parks::Plants;
  use HirakataPapark::Model::MultilingualDelegator::Parks::Equipments;
  use HirakataPapark::Model::MultilingualDelegator::Parks::SurroundingFacilities;
  use HirakataPapark::Service::Park::Searcher::PlantsRowsToPlantsCategories;

  has 'park_tags' => sub ($self) { HirakataPapark::Model::Parks::Tags->new(db => $self->db) };

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

  for my $keyword (qw/ search_by please_input /) {
    has "${keyword}_func" => sub ($self) {
      $self->lang_dict->get_func($keyword)->get
    };
  }

  sub root($self) {
    $self->render;
  }

  sub name($self) {
    $self->stash({
      title       => $self->search_by_func->('name'),
      search_item => 'park_name',
      url         => '/search/like-name',
      placeholder => $self->please_input_func->('park_name'),
    });
    $self->render('searcher/park_column');
  }

  sub address($self) {
    $self->stash({
      title       => $self->search_by_func->('address'),
      search_item => 'park_address',
      url         => '/search/like-address',
      placeholder => $self->please_input_func->('address'),
    });
    $self->render('searcher/park_column');
  }

  # Mojolicious::Plugin::AssetPack で tag というメソッド(helper?)が登録されているため,
  # Controllerでtag というmethodが定義できない
  sub tags($self) {
    my $tag_list = $self->park_tags->get_tag_list;
    $self->stash({
      title       => $self->search_by_func->('tag'),
      url         => '/search/has-tags',
      search_item => 'tags',
      check_boxes => $tag_list
    });
    $self->render('searcher/related_to_park');
  }

  sub plants($self) {
    my $plants_categories = do {
      my $rows = $self->park_plants->get_all_distinct_rows([qw/ name category /]);
      my $s = HirakataPapark::Service::Park::Searcher::PlantsRowsToPlantsCategories->new(rows => $rows);
      $s->exec;
    };
    $self->stash({
      title                   => $self->search_by_func->('plants'),
      search_by_variety_title => $self->search_by_func->('variety'),
      plants_categories       => $plants_categories,
    });
    $self->render('searcher/plants');
  }

  sub equipment($self) {
    my $equipment_list = $self->park_equipments->get_equipment_list;
    $self->stash({
      title        => $self->search_by_func->('equipment'),
      search_item  => 'equipments',
      url          => '/search/has-equipments',
      check_boxes  => $equipment_list,
    });
    $self->render('searcher/related_to_park');
  }

  sub surrounding_facility($self) {
    my $surrounding_facility_list = $self->park_facilities->get_surrounding_facility_list;
    $self->stash({
      title        => $self->search_by_func->('surrounding_facility'),
      search_item  => 'surrounding_facilities',
      url          => '/search/has-surrounding-facilities',
      check_boxes  => $surrounding_facility_list,
    });
    $self->render('searcher/related_to_park');
  }

}

1;

