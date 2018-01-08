package HirakataPapark::Model::Users::ParkEditHistories::Equipment {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use Either;
  use Try::Tiny;
  use Smart::Args qw( args args_pos );
  use HirakataPapark::Util qw( for_yield );
  use HirakataPapark::Model::Users::ParkEditHistories::Equipment::MetaTables;

  # alias
  my $MetaTables =
      'HirakataPapark::Model::Users::ParkEditHistories::Equipment::MetaTables';
  my $HistoryToAdd =
      'HirakataPapark::Model::Users::ParkEditHistories::OneToMany::History::ToAdd';
  my $ResultHistoryBuilder =
      'HirakataPapark::Model::Users::ParkEditHistories::Equipment::ResultHistoryBuilder';

  with 'HirakataPapark::Model::Users::ParkEditHistories::Role::OneToMany';

  sub _build_meta_tables($self) {
    $MetaTables->new(schema => $self->db->schema);
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
      my $table = $self->get_foreign_lang_table_by_lang($lang);
      try {
        right $self->db->insert_multi(
          $table->name,
          $history->items_lang_records_to_params_by_lang($lang, $history_id),
        );
      } catch {
        left $_;
      };
    } HirakataPapark::Types->FOREIGN_LANGS->@*;
    \@results;
  }

  sub get_histories_by_park_id($self, $park_id, $num) {
    my $select = $self->_histories_select($num);
    $select->add_where($self->BODY_TABLE_NAME . '.park_id' => $park_id);
    my $dbh = $self->db->dbh;
    my $sth = $dbh->prepare($select->as_sql);
    $sth->execute($select->bind);
    my $rows = $sth->fetchall_arrayref;
    my @histories = map {
      my $row = $_;
      my $builder = ResultHistoryBuilder->new({
        row    => $row,
        sth    => $sth,
        lang   => HirakataPapark::Types->DEFAULT_LANG,
        tables => $self->tables,
      });
      $builder->build_history;
    } @$rows;
    $self->create_result(\@histories);
  }

  sub get_histories_by_user_seacret_id {
    args my $self, my $lang => 'HirakataPapark::Types::Lang',
      my $user_seacret_id => 'Str',
      my $num             => 'Int';

    my $select = $self->_histories_select($num);
    $select->add_where($self->BODY_TABLE_NAME . '.editer_seacret_id' => $user_seacret_id);
    my $dbh = $self->db->dbh;
    my $sth = $dbh->prepare($select->as_sql);
    $sth->execute($select->bind);
    my $rows = $sth->fetchall_arrayref;
    my @histories = map {
      my $row = $_;
      my $builder = ResultHistoryBuilder->new({
        row    => $row,
        sth    => $sth,
        lang   => $lang,
        tables => $self->tables,
      });
      $builder->build_history;
    } @$rows;
    $self->create_result(\@histories);
  }

  sub _histories_select($self, $num) {
    my $select = $self->db->query_builder->new_select;
    for my $field ($self->body_table->get_fields) {
      $select->add_select($self->BODY_TABLE_NAME . '.' . $field->name);
    }
    for my $lang (HirakataPapark::Types->FOREIGN_LANGS->@*) {
      my $table_name = $self->FOREIGN_LANGS_TABLE_NAMES->{$lang};
      my $sc_maker = $self->select_columns_makers->{$table_name};
      for my $select_column ($sc_maker->select_columns->@*) {
        $select->add_select($select_column);
      }
      $select->add_join(
        $table_name => {
          type      => 'inner',
          table     => $self->BODY_TABLE_NAME,
          condition => $sc_maker->join_condition,
        }
      );
    }
    $select->add_order_by($self->BODY_TABLE_NAME . '.edited_time' => 'DESC');
    $select->limit($num);
    $select;
  }

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

