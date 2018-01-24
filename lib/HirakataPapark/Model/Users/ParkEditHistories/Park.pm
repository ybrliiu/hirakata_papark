package HirakataPapark::Model::Users::ParkEditHistories::Park {

  use Mouse;
  use HirakataPapark;
  use Either;
  use Smart::Args qw( args_pos );
  use aliased 'HirakataPapark::Model::Users::ParkEditHistories::Park::ResultHistoryBuilder';

  # alias
  my $HistoryToAdd =
    'HirakataPapark::Model::Users::ParkEditHistories::History::History::HasOne::ToAdd';

  use constant BODY_TABLE_NAME => 'user_park_edit_history';

  sub foreign_lang_table_name($class) {
    sub ($lang) { "user_${lang}_park_edit_history" };
  }

  with 'HirakataPapark::Model::Users::ParkEditHistories::HasOne';

  sub add_history {
    args_pos my $self, my $history => $HistoryToAdd;
    $history->has_all ? $self->_add_history($history) : left 'History doesnt has all data.';
  }

  sub _create_result_history($self, $row, $sth, $lang) {
    my $builder = ResultHistoryBuilder->new({
      sth         => $sth,
      row         => $row,
      lang        => $lang,
      tables_meta => $self->tables_meta,
    });
    $builder->build;
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

