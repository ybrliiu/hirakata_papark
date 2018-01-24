package HirakataPapark::Model::Users::ParkEditHistories::HasOne {

  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Types;
  use Either;
  use Try::Tiny;
  use Smart::Args;
  use HirakataPapark::Util qw( for_yield );
  use namespace::autoclean;

  with qw(
    HirakataPapark::Model::Role::DB::Multilingual::HasOne
    HirakataPapark::Model::Users::ParkEditHistories::ParkEditHistories
  );

  # methods
  requires qw( _create_result_history );

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
      $self->_create_result_history($row, $sth, HirakataPapark::Types->DEFAULT_LANG);
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
      $self->_create_result_history($row, $sth, $lang);
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

}

1;
