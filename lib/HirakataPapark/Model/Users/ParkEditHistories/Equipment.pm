package HirakataPapark::Model::Users::ParkEditHistories::Equipment {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use Either;
  use Try::Tiny;
  use Smart::Args qw( args args_pos );
  use HirakataPapark::Util qw( for_yield );
  use HirakataPapark::Model::Users::ParkEditHistories::Equipment::TablesMeta;

  # alias
  my $TablesMeta =
      'HirakataPapark::Model::Users::ParkEditHistories::Equipment::TablesMeta';
  my $HistoryToAdd =
      'HirakataPapark::Model::Users::ParkEditHistories::OneToMany::History::ToAdd';
  my $ResultHistoryBuilder =
      'HirakataPapark::Model::Users::ParkEditHistories::Equipment::ResultHistoryBuilder';

  with 'HirakataPapark::Model::Users::ParkEditHistories::Role::OneToMany';

  sub _build_tables_meta($self) {
    $TablesMeta->new(db => $self->db);
  }

  sub add_history {
    args_pos my $self, my $history => $HistoryToAdd;
    $history->has_all ? $self->_add_history($history) : left 'History dont has all data.';
  }

  sub _add_history($self, $history) {
    $self->_insert_to_body_table($history)->flat_map(sub ($history_id) {
      $self->_insert_to_default_lang_table($history, $history_id)->flat_map(sub {
        my $results = $self->_insert_to_foreign_langs_tables($history, $history_id);
        for_yield $results, sub { 'Success add history.' };
      });
    })
  }

  sub _insert_to_body_table($self, $history) {
    try {
      right $self->db->insert_and_fetch_id($self->BODY_TABLE_NAME, $history->to_params);
    } catch {
      left $_;
    };
  }

  sub _insert_to_default_lang_table($self, $history, $history_id) {
    try {
      right $self->db->insert_multi(
        $self->DEFAULT_LANG_TABLE_NAME,
        $history->items_to_params($history_id),
      );
    } catch {
      left $_;
    };
  }

  sub _insert_to_foreign_langs_tables($self, $history, $history_id) {
    my @results = map {
      my $lang = $_;
      my $table_name = $self->get_foreign_lang_table_name_by_lang($lang);
      try {
        right $self->db->insert_multi(
          $table_name,
          $history->items_lang_records_to_params_by_lang($lang, $history_id),
        );
      } catch {
        left $_;
      };
    } HirakataPapark::Types->FOREIGN_LANGS->@*;
    \@results;
  }

  sub get_histories_by_park_id;

  sub get_histories_by_user_seacret_id;

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

History {
  Equipments [
    Equipment1 {
      common_records,
      ja => LangRecord,
      en => LangRecord,
    },
    Equipment2 {
      common_records,
      ja => LangRecord,
      en => LangRecord,
    },
  ]
}

Equipment(モデル本体) -
                 |- TablesMeta(使用するテーブル及びそれに関する情報)
                 |- ResultHistoryBuilder(ResultHistoryを作成するファクトリクラス)

