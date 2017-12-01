package HirakataPapark::Web::Controller::Searcher {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;

  use HirakataPapark::Model::Parks::Tags;
  use HirakataPapark::Model::MultilingualDelegator::Parks::Plants;
  use HirakataPapark::Model::MultilingualDelegator::Parks::Equipments;
  use HirakataPapark::Model::MultilingualDelegator::Parks::SurroundingFacilities;
  use HirakataPapark::Service::Park::Searcher::PlantsRowsToPlantsCategories;

  has 'park_tags' => sub { HirakataPapark::Model::Parks::Tags->new };

  has 'park_plants' => sub ($self) {
    HirakataPapark::Model::MultilingualDelegator::Parks::Plants->new->model( $self->lang );
  };

  has 'park_equipments' => sub ($self) {
    HirakataPapark::Model::MultilingualDelegator::Parks::Equipments->new->model( $self->lang );
  };

  has 'park_facilities' => sub ($self) {
    HirakataPapark::Model::MultilingualDelegator::Parks::SurroundingFacilities->new->model( $self->lang );
  };

  sub root($self) {
    $self->render_to_multiple_lang;
  }

  sub name($self) {
    $self->render_to_multiple_lang;
  }

  sub address($self) {
    $self->render_to_multiple_lang;
  }

  # Mojolicious::Plugin::AssetPack で tag というメソッド(helper?)が登録されているため,
  # Controllerでtag というmethodが定義できない
  sub tags($self) {
    my $tag_list = $self->park_tags->get_tag_list;
    $self->stash(tag_list => $tag_list);
    $self->render_to_multiple_lang(template => 'searcher/tag');
  }

  sub plants($self) {
    my $plants_categories = do {
      my $rows = $self->park_plants->get_all_distinct_rows([qw/ name category /]);
      my $s = HirakataPapark::Service::Park::Searcher::PlantsRowsToPlantsCategories->new(rows => $rows);
      $s->exec;
    };
    $self->stash(plants_categories => $plants_categories);
    $self->render_to_multiple_lang();
  }

  sub equipment($self) {
    my $equipment_list = $self->park_equipments->get_equipment_list;
    $self->stash(equipment_list => $equipment_list);
    $self->render_to_multiple_lang();
  }

  sub surrounding_facility($self) {
    my $surrounding_facility_list = $self->park_facilities->get_surrounding_facility_list;
    $self->stash(surrounding_facility_list => $surrounding_facility_list);
    $self->render_to_multiple_lang();
  }

}

1;

