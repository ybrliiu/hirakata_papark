package HirakataPapark::Model::Users::ParkEditHistories::Plants {

  use Mouse;
  use HirakataPapark;
  use Either;
  use Smart::Args qw( args_pos );
  use aliased
    'HirakataPapark::Model::Users::ParkEditHistories::Plants::ResultHistoryBuilder';

  # alias
  my $HistoryToAdd =
      'HirakataPapark::Model::Users::ParkEditHistories::History::History::HasMany::ToAdd';

  use constant {
    BODY_TABLE_NAME          => 'user_park_plants_edit_history',
    DEFAULT_LANG_TABLE_NAME  => 'user_park_plants_edit_history_row',
  };

  sub foreign_lang_table_name($class) {
    sub ($lang) {
      "user_${lang}_park_plants_edit_history_row";
    };
  }

  with 'HirakataPapark::Model::Users::ParkEditHistories::HasMany';

  sub add_history {
    args_pos my $self, my $history => $HistoryToAdd;
    $history->has_all ? $self->_add_history($history) : left 'History dont has all data.';
  }

  sub _create_result_history($self, $sth, $rows, $lang) {
    my $builder = ResultHistoryBuilder->new({
      sth         => $sth,
      rows        => $rows,
      lang        => $lang,
      tables_meta => $self->tables_meta,
    });
    $builder->build;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__
