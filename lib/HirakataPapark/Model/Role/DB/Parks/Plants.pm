package HirakataPapark::Model::Role::DB::Parks::Plants {

  use Mouse::Role;
  use HirakataPapark;

  use Set::Object;

  # methods
  requires qw(
    get_all_distinct_rows
    get_categories
    get_categories_by_park_id
    get_plants_list
  );

  sub get_row_by_park_id_and_name($self, $park_id, $name) {
    $self->select({
      $self->TABLE . '.park_id' => $park_id,
      $self->TABLE . '.name'    => $name,
    })->first_with_option;
  }

  sub get_rows_by_park_id_order_by_category($self, $park_id) {
    $self->result_class->new([
      $self->select(
        { $self->TABLE . '.park_id' => $park_id },
        { order_by => 'category DESC' }
      )->all
    ]);
  }

  sub get_rows_by_category($self, $category) {
    $self->result_class->new([ $self->select({ $self->TABLE . '.category' => $category })->all ]);
  }

  sub get_rows_by_categories($self, $categories) {
    my @ary = map { ('=', $_) } @$categories;
    $self->result_class->new([ $self->select({ $self->TABLE . '.category' => \@ary })->all ]);
  }

  sub get_park_id_list_has_category_names($self, $category_names) {
    if (@$category_names) {
      my $maker = $self->db->query_builder->select_self;
      my $dbh   = $self->db->dbh;
      my @sql_list = map {
        my $category = $_;
        my $sql = $maker->new
          ->add_from($self->TABLE)
          ->add_select('park_id')
          ->add_where(category => $category);
      } @$category_names;
      my $sql = SQL::Maker::SelectSet::intersect(@sql_list)->as_sql;
      my $result = $dbh->selectall_arrayref($sql, undef, @$category_names);
      [ map { @$_ } @$result ];
    } else {
      [];
    }
  }

}

1;

