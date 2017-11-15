package HirakataPapark::Model::Parks::Plants {

  use Mouse;
  use HirakataPapark;

  use Set::Object;
  use Smart::Args qw( args );

  use constant TABLE => 'park_plants';

  with 'HirakataPapark::Model::Role::DB::RelatedToPark';

  sub add_row {
    args my $self,
      my $park_id          => 'Int',
      my $name             => 'Str',
      my $english_name     => 'Str',
      my $category         => 'Str',
      my $english_category => 'Str',
      my $comment          => { isa => 'Str', default => '' },
      my $english_comment  => { isa => 'Str', default => '' },
      my $num              => { isa => 'Int', default => 0 };

    $self->insert({
      park_id          => $park_id,
      name             => $name,
      english_name     => $english_name,
      category         => $category,
      english_category => $english_category,
      num              => $num,
      comment          => $comment,
      english_comment  => $english_comment,
    });
  }

  sub get_rows_by_park_id_order_by_category($self, $park_id) {
    [ $self->select({park_id => $park_id}, {order_by => 'category DESC'})->all ];
  }

  sub get_rows_by_category($self, $category) {
    [ $self->select({category => $category})->all ];
  }

  sub get_rows_by_categories($self, $categories) {
    my @ary = map { ('=', $_) } @$categories;
    [ $self->select({ category => \@ary })->all ];
  }

  sub get_categories_by_park_id($self, $park_id) {
    [
      map { $_->category } 
      $self->select(
        { park_id => $park_id },
        { prefix => 'SELECT DISTINCT ', columns => ['category'] },
      )->all
    ];
  }

  sub get_english_categories_by_park_id($self, $park_id) {
    [
      map { $_->english_category } 
      $self->select(
        { park_id => $park_id },
        { prefix => 'SELECT DISTINCT ', columns => ['english_category'] },
      )->all
    ];
  }

  sub get_category_list($self) {
    my @category_list =
      map { $_->category } $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => ['category']  } )->all;
    \@category_list;
  }

  sub get_english_category_list($self) {
    my @category_list = map { $_->english_category }
      $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => ['english_category'] } )->all;
    \@category_list;
  }

  sub get_category_list_by_park_id($self, $park_id) {
    my @category_list =
      map { $_->category } $self->select(
        { park_id => $park_id },
        { prefix => 'SELECT DISTINCT ', columns => ['category'] }
      )->all;
    \@category_list;
  }

  sub get_plants_list($self) {
    my @plants_list =
      map { $_->name } $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => ['name'] } )->all;
    \@plants_list;
  }

  sub get_categoryzed_plants_list($self) {
    my @rows = $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => [qw/ name category /] } )->all;
    my $result = +{ map { $_->category => [] } @rows };
    for my $row (@rows) {
      push $result->{$row->category}->@*, $row->name;
    }
    $result;
  }

  sub get_english_categoryzed_plants_list($self) {
    my @rows = $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => [qw/ english_name english_category /] } )->all;
    my $result = +{ map { $_->english_category => [] } @rows };
    for my $row (@rows) {
      push $result->{$row->english_category}->@*, $row->english_name;
    }
    $result;
  }

  sub get_park_id_list_has_category_names($class, $category_names) {
    if (@$category_names) {
      my $maker = $class->default_db->query_builder->select_class;
      my $dbh   = $class->default_db->dbh;
      my @sql_list = map {
        my $category = $_;
        my $sql = $maker->new
          ->add_from($class->TABLE)
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

  sub get_park_id_list_has_english_category_names($class, $category_names) {
    if (@$category_names) {
      my $maker = $class->default_db->query_builder->select_class;
      my $dbh   = $class->default_db->dbh;
      my @sql_list = map {
        my $category = $_;
        my $sql = $maker->new
          ->add_from($class->TABLE)
          ->add_select('park_id')
          ->add_where(english_category => $category);
      } @$category_names;
      my $sql = SQL::Maker::SelectSet::intersect(@sql_list)->as_sql;
      my $result = $dbh->selectall_arrayref($sql, undef, @$category_names);
      [ map { @$_ } @$result ];
    } else {
      [];
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

