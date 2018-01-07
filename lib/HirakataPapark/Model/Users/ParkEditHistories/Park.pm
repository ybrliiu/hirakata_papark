package HirakataPapark::Model::Users::ParkEditHistories::Park {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use Either;
  use Try::Tiny;
  use Smart::Args qw( args args_pos );
  use HirakataPapark::Util qw( for_yield );
  use HirakataPapark::Model::Users::ParkEditHistories::Park::Tables;
  use HirakataPapark::Model::Users::ParkEditHistories::Park::ResultHistoryBuilder;

  # alias
  use constant {
    Tables => 
      'HirakataPapark::Model::Users::ParkEditHistories::Park::Tables',
    AddHistory => 
      'HirakataPapark::Model::Users::ParkEditHistories::Park::History::Add',
    ResultHistoryBuilder => 
      'HirakataPapark::Model::Users::ParkEditHistories::Park::ResultHistoryBuilder',
  };

  with 'HirakataPapark::Model::Users::ParkEditHistories::Base';

  sub _build_tables($self) {
    Tables->new(db => $self->db);
  }

  sub add_history {
    args_pos my $self, my $history => AddHistory;
    $history->has_all ? $self->_add_history($history) : left 'History dont has all data.';
  }

  sub _add_history($self, $history) {
    my $edited_time = time;
    my $history_params = {
      edited_time => $edited_time,
      map { $_ => $history->$_ } (
        'editer_seacret_id',
        map { "park_$_" } qw( id name zipcode address explain x y area is_evacuation_area )
      ),
    };
    my $result = try {
      right $self->db->insert_and_fetch_id($self->BODY_TABLE_NAME, $history_params);
    } catch {
      left $_
    };
    $result->flat_map(sub ($history_id) {
      my $results = $self->_insert_to_foreign_langs_tables($history, $history_id);
      for_yield $results, sub { 'Success add history.' };
    });
  }

  sub _insert_to_foreign_langs_tables($self, $history, $history_id) {
    my @results = map {
      my $lang = $_;
      my $table_name = $self->FOREIGN_LANGS_TABLE_NAMES->{$lang};
      my $params = $history->foreign_lang_table_sets->get_sets($lang)->get->to_params;
      $params->{history_id} = $history_id;
      try {
        right $self->db->insert( $table_name, $params );
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

