package HirakataPapark::Model::Users::ParkEditHistories::Park {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use Either;
  use Try::Tiny;
  use Smart::Args qw( args_pos );
  use HirakataPapark::Util qw( for_yield );
  use HirakataPapark::Class::ISO639_1Translator qw( to_word );

  use constant {
    TABLE_NAME                => 'user_park_edit_history',
    FOREIGN_LANGS_TABLE_NAMES => +{
      map { $_ => 'user_' . to_word $_ . '_park_edit_history' }
        HirakataPapark::Types->FOREIGN_LANGS->@*
    },
  };

  # alias
  use constant {
    AddHistory    => 'HirakataPapark::Model::Users::ParkEditHistories::Park::History::Add',
    ResultHistory => 'HirakataPapark::Model::Users::ParkEditHistories::Park::History::Result',
  };

  with 'HirakataPapark::Model::Users::ParkEditHistories::Base';

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
      right $self->db->insert_and_fetch_id($self->TABLE_NAME, $history_params);
    } catch {
      left $_
    };
    $result->flat_map(sub {
      my $results = $self->_insert_to_foreign_langs_tables($history, $history_id);
      for_yield $results, sub { 'Success add history.' };
    });
  }

  sub _insert_to_foreign_langs_tables($self, $history, $history_id) {
    my @results = map {
      my $lang = $_;
      my $table_name = $self->FOREIGN_LANGS_TABLE_NAMES->{$lang};
      my $params = $history->foreign_lang_values->get_sets($lang)->get->to_params;
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
  }

  sub get_histories_by_user_seacret_id($self, $lang, $user_seacret_id, $num) {
    my $select = $self->db->query_builder->new_select;

    for my $key ( keys $self->FOREIGN_LANGS_TABLE_NAMES->%* ) {
      my $table_name = $self->FOREIGN_LANGS_TABLE_NAMES->{$key};
      $select->add_join(
        $table_name => {
          type      => 'inner',
          table     => $self->TABLE_NAME,
          condition => { $self->TABLE_NAME . '.id' => "$table_name.history_id" },
        }
      );
    }

    while (my ($col, $val) = each %$where) {
      $select->add_where($col => $val);
    }

    _add_option($select, $opt, $_) for qw( limit offset prefix );
    _add_options($select, $opt, $_) for qw( order_by group_by );

    $self->db->select_by_sql($select->as_sql, [$select->bind], { %$opt, table_name => $self->TABLE });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

=encoding utf8

=head1 DESCRIPTION

ユーザーの公園編集履歴をDBから取得,もしくはDBに格納するモジュールです。
このモジュールではAniki::Rowを返さず、代わりにHistoryオブジェクトを返すので注意して下さい。

=head1 METHODS

=head2 add_history

ユーザーが履歴を追加するときに使用するメソッドで、Historyを受け取りその中身に基づいてDBに値を格納
格納する時に全ての言語のデータがあるかを確認

ユーザーが公園データを編集 -> 送信されたデータ、言語に基づいて足りないデータを補完 -> 格納
もしくは
ユーザーが公園データを全て補完 -> 格納

=head2 add_add_lang_history

最初に公園のデータを一気に

=cut

