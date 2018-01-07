package HirakataPapark::Model::Users::ParkEditHistories::Equipment {


  __PACKAGE__->meta->make_immutable;

}

1;

__END__

History {
  Equipments [
    Equipment1 {
      common_records,
      ja => DiffColumnSets,
      en => DiffColumnSets,
    },
    Equipment2 {
      common_records,
      ja => DiffColumnSets,
      en => DiffColumnSets,
    },
  ]
}

Equipment(モデル本体) -
                 |- History(モデルが返すオブジェクト, 履歴データが格納された全てのテーブルから取ってきた情報が格納される)
                 |- ForeignLangTableSets(履歴情報のうち、外国語テーブルに格納するデータの集合)
                 |- DiffRowsSets(DiffColumnSetsの集合, その履歴の時点での
                 |- DiffColumnSets(外国語テーブルに格納するカラムのデータクラス)
                 |- SelectColumnsMaker(データベースから取ってくるデータのカラムを求めるクラス)
                 |- DB(データベースに関する情報)
                 |- ResultHistoryBuilder(ResultHistoryを作成するファクトリクラス)

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

