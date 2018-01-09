package HirakataPapark::Model::Users::ParkEditHistories::Plants {

  use Mouse;
  use HirakataPapark;
  use Either;
  use Smart::Args qw( args_pos );
  use HirakataPapark::Model::Users::ParkEditHistories::Plants::MetaTables;
  use HirakataPapark::Model::Users::ParkEditHistories::Plants::ResultHistoryBuilder;

  # alias
  my $MetaTables =
      'HirakataPapark::Model::Users::ParkEditHistories::Plants::MetaTables';
  my $HistoryToAdd =
      'HirakataPapark::Model::Users::ParkEditHistories::History::History::HasMany::ToAdd';
  my $ResultHistoryBuilder =
      'HirakataPapark::Model::Users::ParkEditHistories::Plants::ResultHistoryBuilder';

  with 'HirakataPapark::Model::Users::ParkEditHistories::HasMany';

  sub _build_meta_tables($self) {
    $MetaTables->new(schema => $self->db->schema);
  }

  sub add_history {
    args_pos my $self, my $history => $HistoryToAdd;
    $history->has_all ? $self->_add_history($history) : left 'History dont has all data.';
  }

  sub _create_result_history($self, $sth, $rows, $lang) {
    my $builder = $ResultHistoryBuilder->new({
      sth         => $sth,
      rows        => $rows,
      lang        => $lang,
      meta_tables => $self->meta_tables,
    });
    $builder->build;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__
