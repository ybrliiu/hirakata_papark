package HirakataPapark::Web::Controller::Searcher {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;

  use HirakataPapark::Model::Parks::Tags;
  use HirakataPapark::Model::Parks::Plants;
  use HirakataPapark::Model::Parks::Equipments;
  use HirakataPapark::Model::Parks::SurroundingFacilities;

  has 'park_tags'       => sub { HirakataPapark::Model::Parks::Tags->new };
  has 'park_plants'     => sub { HirakataPapark::Model::Parks::Plants->new };
  has 'park_equipments' => sub { HirakataPapark::Model::Parks::Equipments->new };
  has 'park_facilities' => sub { HirakataPapark::Model::Parks::SurroundingFacilities->new };

  sub root {
    my $self = shift;
    $self->render_to_multiple_lang();
  }

  sub name {
    my $self = shift;
    $self->render_to_multiple_lang();
  }

  sub address {
    my $self = shift;
    $self->render_to_multiple_lang();
  }

  # Mojolicious::Plugin::AssetPack で tag というメソッド(helper?)が登録されているため,
  # Controllerでtag というmethodが定義できない
  sub tags {
    my $self = shift;
    my $tag_list = $self->park_tags->get_tag_list();
    $self->stash(tag_list => $tag_list);
    $self->render_to_multiple_lang(template => 'searcher/tag');
  }

  sub plants {
    my $self = shift;
    my $park_plants = $self->park_plants;
    my ($plants_categories, $categoryzed_plants) = $self->lang eq 'en'
        ? ( $park_plants->get_english_category_list, $park_plants->get_english_categoryzed_plants_list )
        : ( $park_plants->get_category_list, $park_plants->get_categoryzed_plants_list );
    $self->stash({
      plants_categories  => $plants_categories,
      categoryzed_plants => $categoryzed_plants,
    });
    $self->render_to_multiple_lang();
  }

  sub equipment {
    my $self = shift;
    my $equipment_list = $self->lang eq 'en'
      ? $self->park_equipments->get_english_equipment_list
      : $self->park_equipments->get_equipment_list;
    $self->stash(equipment_list => $equipment_list);
    $self->render_to_multiple_lang();
  }

  sub surrounding_facility {
    my $self = shift;
    my $surrounding_facility_list = $self->lang eq 'en'
      ? $self->park_facilities->get_english_surrounding_facility_list
      : $self->park_facilities->get_surrounding_facility_list;
    $self->stash(surrounding_facility_list => $surrounding_facility_list);
    $self->render_to_multiple_lang();
  }

}

1;

