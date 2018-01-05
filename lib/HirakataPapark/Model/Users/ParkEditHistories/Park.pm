package HirakataPapark::Model::Users::ParkEditHistories::Park {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use Either;
  use Try::Tiny;
  use Smart::Args qw( args_pos );
  use HirakataPapark::Util qw( for_yield );
  use HirakataPapark::Class::ISO639_1Translator qw( to_word );
  use HirakataPapark::Model::Role::DB::ForeignLanguage::SelectColumnsMaker;

  use constant {
    TABLE_NAME                => 'user_park_edit_history',
    FOREIGN_LANGS_TABLE_NAMES => +{
      map { $_ => 'user_' . to_word($_) . '_park_edit_history' }
        HirakataPapark::Types->FOREIGN_LANGS->@*
    },
  };

  # alias
  use constant {
    AddHistory    => 'HirakataPapark::Model::Users::ParkEditHistories::Park::History::Add',
    ResultHistory => 'HirakataPapark::Model::Users::ParkEditHistories::Park::History::Result',
  };

  has 'foreign_lang_tables' => (
    is      => 'ro',
    isa     => 'HashRef[Aniki::Schema::Table]',
    lazy    => 1,
    builder => '_build_foreign_lang_tables',
  );

  with 'HirakataPapark::Model::Users::ParkEditHistories::Base';

  sub _build_foreign_lang_tables($self) {
    my %tables = map {
      my $table_name = $self->FOREIGN_LANGS_TABLE_NAMES->{$_};
      $_ => $self->_table_builder($table_name);
    } keys $self->FOREIGN_LANGS_TABLE_NAMES->%*;
    \%tables;
  }

  sub _build_select_columns_makers($self) {
    my %makers = map {
      my $table = $self->foreign_lang_tables->{$_};
      my $sc_maker =
        HirakataPapark::Model::Role::DB::ForeignLanguage::SelectColumnsMaker->new({
          schema          => $self->db->schema,
          table           => $table,
          orig_lang_table => $self->table,
          table_name      => $self->TABLE_NAME,
          orig_lang_table_name => $table->name,
        });
      $table->name => $sc_maker;
    } HirakataPapark::Types->FOREIGN_LANGS->@*;
    \%makers;
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
      right $self->db->insert_and_fetch_id($self->TABLE_NAME, $history_params);
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

  sub get_histories_select($self, $num) {
    my $select = $self->db->query_builder->new_select;
    for my $lang (keys $self->FOREIGN_LANGS_TABLE_NAMES->%*) {
      my $table_name = $self->FOREIGN_LANGS_TABLE_NAMES->{$lang};
      my $sc_maker = $self->select_columns_makers->{$table_name};
      my $columns = $sc_maker->select_columns;
      for my $column (@$columns) {
        $select->add_select($column);
      }
      $select->add_join(
        $table_name => {
          type      => 'inner',
          table     => $self->TABLE_NAME,
          condition => { $self->TABLE_NAME . '.id' => "$table_name.history_id" },
        }
      );
    }

    $select->add_order_by($self->TABLE_NAME . '.edited_time' => 'DESC');
    $select->limit($num);
    $select;
  }

  sub get_histories_by_park_id($self, $park_id, $num) {
    my $select = $self->get_histories_select($num);
    $select->add_where($self->TABLE_NAME . '.park_id' => $park_id);
    my $result = $self->db->dbh->selectall_hashref(
      $select->as_sql, 
      $self->TABLE_NAME . '.user_seacret_id',
      {},
      $select->bind,
    );
  }

  sub get_histories_by_user_seacret_id($self, $user_seacret_id, $num) {
    my $select = $self->get_histories_select($num);
    $select->add_where($self->TABLE_NAME . '.editer_seacret_id' => $user_seacret_id);
    my $result = $self->db->dbh->selectall_hashref(
      $select->as_sql, 
      'edited_time',
      {},
      $select->bind,
    );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

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

