package HirakataPapark::Model::Users::ParkEditHistories::HasMany {

  use Mouse::Role;
  use HirakataPapark;
  use Either;
  use Try::Tiny;
  use Smart::Args ();
  use HirakataPapark::Util ();
  use namespace::autoclean;

  with 'HirakataPapark::Model::Users::ParkEditHistories::ParkEditHistories';

  my $MetaTables =
    'HirakataPapark::Model::Users::ParkEditHistories::MetaTables::HasMany::MetaTables';
  sub meta_tables;
  has 'meta_tables' => (
    is      => 'ro',
    does    => $MetaTables,
    handles => [qw(
      BODY_TABLE_NAME
      DEFAULT_LANG_TABLE_NAME
      get_foreign_lang_table_by_lang
      body_table
      default_lang_table
      foreign_lang_tables
      tables
      join_tables
    )],
    lazy    => 1,
    builder => '_build_meta_tables',
  );

  # methods
  requires qw( _build_meta_tables _create_result_history );

  sub _add_history($self, $history) {
    $self->_insert_to_body_table($history)->flat_map(sub ($history_id) {
      $self->_insert_to_default_lang_table($history, $history_id)->flat_map(sub ($rows) {
        my $results = $self->_insert_to_foreign_langs_tables($history, $history_id);
        HirakataPapark::Util::for_yield $results, sub { 'Success add history.' };
      });
    })
  }

  sub _insert_to_body_table($self, $history) {
    try {
      right $self->db->insert_and_fetch_id($self->body_table->name, $history->to_params);
    } catch {
      left $_;
    };
  }

  sub _insert_to_default_lang_table($self, $history, $history_id) {
    try {
      right $self->db->insert_multi(
        $self->default_lang_table->name,
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
          $history->items_lang_record_to_params($lang, $history_id),
        );
      } catch {
        left $_;
      };
    } HirakataPapark::Types->FOREIGN_LANGS->@*;
    \@results;
  }

  sub get_histories_by_park_id($self, $park_id, $num) {
    my ($query, $sub_query) = $self->_histories_select($num);
    my $body_table = $self->body_table;
    $sub_query->add_where($body_table->name . '.park_id' => $park_id);
    $query->add_where($body_table->name . '.' . $body_table->pkey->name => {
      IN => \[$sub_query->as_sql, $sub_query->bind]
    });

    my $dbh = $self->db->dbh;
    my $sth = $dbh->prepare($query->as_sql);
    $sth->execute($query->bind);
    my $rows = $sth->fetchall_arrayref;
    $self->_create_result_histories($sth, $rows, HirakataPapark::Types->DEFAULT_LANG);
  }

  sub get_histories_by_user_seacret_id {
    Smart::Args::args my $self, my $lang => 'HirakataPapark::Types::Lang',
      my $user_seacret_id => 'Str',
      my $num             => 'Int';

    my ($query, $sub_query) = $self->_histories_select($num);
    my $body_table = $self->body_table;
    $sub_query->add_where($body_table->name . '.editer_seacret_id' => $user_seacret_id);
    $query->add_where($body_table->name . '.' . $body_table->pkey->name => {
      IN => \[$sub_query->as_sql, $sub_query->bind]
    });
    
    my $dbh = $self->db->dbh;
    my $sth = $dbh->prepare($query->as_sql);
    $sth->execute($query->bind);
    my $rows = $sth->fetchall_arrayref;
    $self->_create_result_histories($sth, $rows, $lang);
  }

  sub _create_result_histories($self, $sth, $rows, $lang) {
    my $ID_INDEX = 0;
    my ($begin_index, $before_id) = (0, -1);
    my @histories;
    my @rows = @$rows;
    for my $i (0 .. $#rows) {
      my $row = $rows[$i];
      if ($before_id != $row->[$ID_INDEX]) {
        if ($i - $begin_index > 0) {
          my @history_rows = @rows[$begin_index .. $i - 1];
          push @histories, $self->_create_result_history($sth, \@history_rows, $lang);
        }
        $begin_index = $i;
      }
      elsif ($i == $#rows) {
        my @history_rows = @rows[$begin_index .. $i];
        push @histories, $self->_create_result_history($sth, \@history_rows, $lang);
      }
      $before_id = $row->[$ID_INDEX];
    }
    $self->create_result(\@histories);
  }

  sub _histories_select($self, $num) {
    my $sub_query = $self->db->query_builder->new_select;
    my $body_table = $self->body_table;
    $sub_query->add_from($body_table->name);
    $sub_query->add_select($body_table->name . '.' . $body_table->pkey->name);
    $sub_query->add_order_by($body_table->name . '.edited_time' => 'DESC');
    $sub_query->limit($num);

    my $query = $self->db->query_builder->new_select;
    for my $table ($self->join_tables->@*) {
      $query->add_join(
        $body_table->name => {
          type      => 'inner',
          table     => $table->name,
          condition => $table->join_condition,
        }
      );
    }

    for my $table ($self->tables->@*) {
      for my $column ($table->select_columns->@*) {
        $query->add_select($column);
      }
    }

    ($query, $sub_query);
  }

}

1;
