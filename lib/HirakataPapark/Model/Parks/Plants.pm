package HirakataPapark::Model::Parks::Plants {

  use Mouse;
  use HirakataPapark;

  use Set::Object;
  use Smart::Args qw( args );

  use constant TABLE => 'park_plants';

  with 'HirakataPapark::Model::Role::DB::RelatedToPark';

  sub add_row {
    args my $self, my $park_id => 'Int',
      my $name     => 'Str',
      my $category => 'Str',
      my $num      => { isa => 'Int', default => 0 },
      my $comment  => { isa => 'Str', default => '' };
    $self->insert({
      park_id  => $park_id,
      name     => $name,
      category => $category,
      num      => $num,
      comment  => $comment,
    });
  }

  sub get_rows_by_category($self, $category) {
    [ $self->select({category => $category})->all ];
  }

  sub get_rows_by_categories($self, $categories) {
    my @ary = map { ('=', $_) } @$categories;
    [ $self->select({ category => \@ary })->all ];
  }

  sub get_category_list($self) {
    my @category_list =
      map { $_->category } $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => ['category']  } )->all;
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

  __PACKAGE__->meta->make_immutable;

}

1;

