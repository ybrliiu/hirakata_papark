package HirakataPapark::Model::Users::ParkEditHistories::History::History::HasMany::ToAdd {

  use Mouse;
  use HirakataPapark;
  with 'HirakataPapark::Model::Users::ParkEditHistories::History::History::HasMany::History';

  sub to_params($self) {
    +{ map { $_ => $self->$_ } $self->COLUMN_NAMES->@* };
  }

  sub items_to_params($self, $history_id) {
    $self->items_map(sub ($item) {
      $item->to_params($history_id);
    });
  }

  sub items_lang_record_to_params($self, $lang, $history_id) {
    $self->items_map(sub ($item) {
      $item->lang_records
        ->${\$lang}->get
        ->maybe_to_params($history_id)->get;
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;
