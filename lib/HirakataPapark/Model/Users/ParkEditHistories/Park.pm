package HirakataPapark::Model::Users::ParkEditHistories::Park {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use Either;
  use Try::Tiny;
  use Smart::Args qw( args args_pos );
  use HirakataPapark::Util qw( for_yield );
  use HirakataPapark::Model::Users::ParkEditHistories::Park::MetaTables;
  use HirakataPapark::Model::Users::ParkEditHistories::Park::ResultHistoryBuilder;

  # alias
  my $MetaTables =
      'HirakataPapark::Model::Users::ParkEditHistories::Park::MetaTables';
  my $HistoryToAdd =
      'HirakataPapark::Model::Users::ParkEditHistories::History::History::HasOne::ToAdd';
  my $ResultHistoryBuilder =
      'HirakataPapark::Model::Users::ParkEditHistories::Park::ResultHistoryBuilder';

  with 'HirakataPapark::Model::Users::ParkEditHistories::HasOne';

  sub _build_meta_tables($self) {
    $MetaTables->new(schema => $self->db->schema);
  }

  sub add_history {
    args_pos my $self, my $history => $HistoryToAdd;
    $history->has_all ? $self->_add_history($history) : left 'History doesnt has all data.';
  }

  sub _add_history($self, $history) {
    $self->_insert_to_body_table($history)->flat_map(sub ($history_id) {
      my $results = $self->_insert_to_foreign_langs_tables($history, $history_id);
      for_yield $results, sub { 'Success add history.' };
    });
  }

  sub _insert_to_body_table($self, $history) {
    try {
      my $body_table = $self->body_table;
      right $self->db->insert_and_fetch_id($body_table->name, $history->to_params);
    } catch {
      left $_
    };
  }

  sub _insert_to_foreign_langs_tables($self, $history, $history_id) {
    my @results = map {
      my $table = $_;
      try {
        right $self->db->insert(
          $table->name,
          $history->lang_record_to_params($table->lang, $history_id)
        );
      } catch {
        left $_;
      };
    } $self->foreign_lang_tables->@*;
    \@results;
  }

  sub get_histories_by_park_id($self, $park_id, $num) {
    my $select = $self->_histories_select($num);
    $select->add_where($self->body_table->name . '.park_id' => $park_id);
    my $dbh = $self->db->dbh;
    my $sth = $dbh->prepare($select->as_sql);
    $sth->execute($select->bind);
    my $rows = $sth->fetchall_arrayref;
    my @histories = map {
      my $row = $_;
      my $builder = $ResultHistoryBuilder->new({
        row         => $row,
        sth         => $sth,
        lang        => HirakataPapark::Types->DEFAULT_LANG,
        meta_tables => $self->meta_tables,
      });
      $builder->build;
    } @$rows;
    $self->create_result(\@histories);
  }

  sub get_histories_by_user_seacret_id {
    args my $self, my $lang => 'HirakataPapark::Types::Lang',
      my $user_seacret_id => 'Str',
      my $num             => 'Int';

    my $select = $self->_histories_select($num);
    $select->add_where($self->body_table->name . '.editer_seacret_id' => $user_seacret_id);
    my $dbh = $self->db->dbh;
    my $sth = $dbh->prepare($select->as_sql);
    $sth->execute($select->bind);
    my $rows = $sth->fetchall_arrayref;
    my @histories = map {
      my $row = $_;
      my $builder = $ResultHistoryBuilder->new({
        row         => $row,
        sth         => $sth,
        lang        => $lang,
        meta_tables => $self->meta_tables,
      });
      $builder->build;
    } @$rows;
    $self->create_result(\@histories);
  }

  sub _histories_select($self, $num) {
    my $select = $self->db->query_builder->new_select;
    for my $table ($self->join_tables->@*) {
      $select->add_join($table->name => {
          type      => 'inner',
          table     => $self->body_table->name,
          condition => $table->join_condition,
      });
    }
    for my $table ($self->tables->@*) {
      for my $column_name ($table->select_columns->@*) {
        $select->add_select($column_name);
      }
    }
    $select->add_order_by($self->body_table->name . '.edited_time' => 'DESC');
    $select->limit($num);
    $select;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

Park(モデル本体) -
                 |- History(モデルが返すオブジェクト, 履歴データが格納された全てのテーブルから取ってきた情報が格納される)
                 |- ForeignLangTableSets(履歴情報のうち、外国語テーブルに格納するデータの集合)
                 |- DiffColumnSets(外国語テーブルに格納するカラムのデータクラス)
                 |- SelectColumnsMaker(データベースから取ってくるデータのカラムを求めるクラス)
                 |- Tables(関連テーブルに関する情報)
                 |- ResultHistoryBuilder(DBのレコードからResultHistoryを組み立てるクラス)

=encoding utf8

=head1 DESCRIPTION

ユーザーの公園編集履歴をDBから取得,もしくはDBに格納するモジュールです。

=head1 METHODS

=head2 add_history

ユーザーが履歴を追加するときに使用するメソッドで、Historyを受け取りその中身に基づいてDBに値を格納
格納する時に全ての言語のデータがあるかを確認

ユーザーが公園データを編集 -> 送信されたデータ、言語に基づいて足りないデータを補完 -> 格納
もしくは
ユーザーが公園データを全て補完 -> 格納

=head2 get_histories_by_park_id

Historyオブジェクトが返ります

=head2 get_histories_by_user_seacret_id

=cut

