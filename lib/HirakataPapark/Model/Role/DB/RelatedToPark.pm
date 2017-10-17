package HirakataPapark::Model::Role::DB::RelatedToPark {

  use Mouse::Role;
  use HirakataPapark;
  use SQL::Maker::SelectSet;

  with 'HirakataPapark::Model::Role::DB';

  requires qw( add_row );

  sub get_rows_by_park_id($self, $park_id) {
    [ $self->select({park_id => $park_id})->all ];
  }

  sub get_rows_by_name($self, $name) {
    [ $self->select({ name => $name })->all ];
  }

  sub get_rows_by_names($self, $names) {
    my @ary = map { ('=', $_) } @$names;
    [ $self->select({ name => \@ary })->all ];
  }

  sub get_rows_by_names_with_prefetch($self, $names) {
    my @ary = map { ('=', $_) } @$names;
    [ $self->select( { name => \@ary }, { prefetch => ['park'] } )->all ];
  }

  # and (?)
  sub get_park_id_list_has_names($class, $names) {
    if (@$names) {
      my $maker = $class->default_db->query_builder->select_class;
      my $dbh   = $class->default_db->dbh;
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

}

1;

