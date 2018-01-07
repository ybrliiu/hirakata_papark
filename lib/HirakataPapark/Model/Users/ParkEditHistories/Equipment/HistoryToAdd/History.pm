package HirakataPapark::Model::Users::ParkEditHistories::Equipment::HistoryToAdd::History {

  use Mouse;
  use HirakataPapark;
  with 'HirakataPapark::Model::Users::ParkEditHistories::Equipment::History::History';

  sub equipments_to_params($self, $history_id) {
    $self->equipments_map(sub ($equipment) {
      $equipment->to_params($history_id);
    });
  }

  sub equipments_lang_records_to_params_by_lang($self, $lang, $history_id) {
    $self->equipments_map(sub ($equipment) {
      $equipment->lang_records->get_lang_record($lang)->maybe_to_params($history_id)->get;
    });
  }

  sub to_params($self) {
    +{ map { $_ => $self->$_ } qw( park_id editer_seacret_id edited_time ) };
  }

  __PACKAGE__->meta->make_immutable;

}

1;
