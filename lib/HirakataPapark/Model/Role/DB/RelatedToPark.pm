package HirakataPapark::Model::Role::DB::RelatedToPark {

  use Mouse::Role;
  use HirakataPapark;
  use SQL::Maker::SelectSet;

  requires qw( HANDLE_TABLE_NAME );

  requires qw( db create_result );

  sub get_row($self, $park_id, $name) {
    $self->select({
      $self->HANDLE_TABLE_NAME . '.park_id' => $park_id,
      $self->HANDLE_TABLE_NAME . '.name'    => $name,
    })->first_with_option;
  }

  sub get_rows_by_park_id($self, $park_id) {
    $self->create_result( $self->select({ $self->HANDLE_TABLE_NAME . '.park_id' => $park_id })->rows );
  }

  sub get_rows_by_name($self, $name) {
    $self->create_result( $self->select({ $self->HANDLE_TABLE_NAME . '.name' => $name })->rows );
  }

  sub get_rows_by_names($self, $names) {
    my @ary = map { ('=', $_) } @$names;
    $self->create_result( $self->select({ $self->HANDLE_TABLE_NAME . '.name' => \@ary })->rows );
  }

  # and (?)
  sub get_park_id_list_has_names($class, $names) {
    if (@$names) {
      my $maker = $class->db->query_builder->select_class;
      my $dbh   = $class->db->dbh;
      my @sql_list = map {
        my $name = $_;
        my $sql = $maker->new
          ->add_from($class->HANDLE_TABLE_NAME)
          ->add_select('park_id')
          ->add_where(name => $name);
      } @$names;
      my $sql = SQL::Maker::SelectSet::intersect(@sql_list)->as_sql;
      my $result = $dbh->selectall_arrayref($sql, undef, @$names);
      [ map { @$_ } @$result ];
    } else {
      [];
    }
  }

}

1;

