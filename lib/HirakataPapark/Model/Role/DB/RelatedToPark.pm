package HirakataPapark::Model::Role::DB::RelatedToPark {

  use Mouse::Role;
  use HirakataPapark;
  use SQL::Maker::SelectSet;

  # constants
  requires qw( TABLE );

  # attributes
  requires qw( db );

  # methods
  requires qw( add_row select );

  sub get_row_by_park_id_and_name($self, $park_id, $name) {
    $self->select({
      $self->TABLE . '.park_id' => $park_id,
      $self->TABLE . '.name'    => $name,
    })->first_with_option;
  }

  sub get_rows_by_park_id($self, $park_id) {
    $self->result_class->new([ $self->select({ $self->TABLE . '.park_id' => $park_id })->all ]);
  }

  sub get_rows_by_name($self, $name) {
    $self->result_class->new([ $self->select({ $self->TABLE . '.name' => $name })->all ]);
  }

  sub get_rows_by_names($self, $names) {
    my @ary = map { ('=', $_) } @$names;
    $self->result_class->new([ $self->select({ $self->TABLE . '.name' => \@ary })->all ]);
  }

  sub PREFETCH_TABLE_NAME { 'park' }

  sub get_rows_by_names_with_prefetch($self, $names) {
    my @ary = map { ('=', $_) } @$names;
    $self->result_class->new([ $self->select( { $self->TABLE . '.name' => \@ary }, { prefetch => [$self->PREFETCH_TABLE_NAME] } )->all ]);
  }

  # and (?)
  sub get_park_id_list_has_names($class, $names) {
    if (@$names) {
      my $maker = $class->db->query_builder->select_class;
      my $dbh   = $class->db->dbh;
      my @sql_list = map {
        my $name = $_;
        my $sql = $maker->new
          ->add_from($class->TABLE)
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

  sub get_park_id_list_has_english_names($class, $names) {
    if (@$names) {
      my $maker = $class->db->query_builder->select_class;
      my $dbh   = $class->db->dbh;
      my @sql_list = map {
        my $name = $_;
        my $sql = $maker->new
          ->add_from($class->TABLE)
          ->add_select('park_id')
          ->add_where(english_name => $name);
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

