package HirakataPapark::Model::Users::ParkEditHistories::OneToMany::History::ToAdd {

  use Mouse;
  use HirakataPapark;
  with 'HirakataPapark::Model::Users::ParkEditHistories::OneToMany::History::History';

  sub to_params($self) {
    +{ map { $_ => $self->$_ } qw( park_id editer_seacret_id edited_time ) };
  }

  sub items_to_params($self, $history_id) {
    $self->items_map(sub ($item) {
      $item->to_params($history_id);
    });
  }

  sub items_lang_records_to_params_by_lang($self, $lang, $history_id) {
    $self->items_map(sub ($item) {
      $item->lang_records
        ->${\$lang}->get
        ->maybe_to_params($history_id)->get;
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;
