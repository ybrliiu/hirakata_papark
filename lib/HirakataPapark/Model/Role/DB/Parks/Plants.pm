package HirakataPapark::Model::Role::DB::Parks::Plants {

  use Mouse::Role;
  use HirakataPapark;

  # methods
  requires qw(
    get_all_distinct_rows
    get_categories
    get_categories_by_park_id
    get_plants_list
  );

  sub get_rows_by_park_id_order_by_category($self, $park_id) {
    $self->create_result(
      $self->select(
        { $self->TABLE . '.park_id' => $park_id },
        { order_by => 'category DESC' }
      )->rows
    );
  }

  sub get_rows_by_category($self, $category) {
    $self->create_result( $self->select({ $self->TABLE . '.category' => $category })->rows );
  }

  sub get_rows_by_categories($self, $categories) {
    my @ary = map { ('=', $_) } @$categories;
    $self->create_result( $self->select({ $self->TABLE . '.category' => \@ary })->rows );
  }

  sub get_park_id_list_has_category_names($self, $category_names) {
    if (@$category_names) {
      my $maker = $self->db->query_builder->select_class;
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

