package HirakataPapark::Model::Parks::Equipments {

  use Mouse;
  use HirakataPapark;

  use Encode;
  use SQL::Maker::SelectSet qw( intersect );
  use Smart::Args qw( args args_pos );

  use constant TABLE => 'park_equipment';

  with 'HirakataPapark::Model::Role::DB';

  sub add_row {
    args my $self, my $park_id => 'Int', my $name => 'Str',
      my $recommended_age => { isa => 'Int', default => 0 },
      my $comment         => { isa => 'Str', default => '' },
      my $num             => { isa => 'Int', default => 1 };
    $self->insert({
      park_id         => $park_id,
      name            => $name,
      recommended_age => $recommended_age,
      comment         => $comment,
      num             => $num,
    });
  }

  sub get_rows_by_name {
    args_pos my $self, my $name => 'Str';
    [ $self->select({name => $name})->all ];
  }

  sub get_rows_by_names {
    args_pos my $self, my $names => 'ArrayRef[Str]';
    my @ary = map { ('=', $_) } @$names;
    [ $self->select({ name => \@ary })->all ];
  }

  sub get_rows_by_names_with_prefetch {
    args_pos my $self, my $names => 'ArrayRef[Str]';
    my @ary = map { ('=', $_) } @$names;
    [ $self->select( { name => \@ary }, { prefetch => ['park'] } )->all ];
  }

  sub get_equipment_list {
    my $self = shift;
    my @tag_list =
      map { $_->name } $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => ['name'] } )->all;
    \@tag_list;
  }

  # and
  sub get_park_id_list_has_names {
    args_pos my $class, my $names => 'ArrayRef[Str]';
    my $maker = $class->default_db->query_builder->select_class;
    my $dbh   = $class->default_db->dbh;
    my @sql_list = map {
      my $name = $_;
      my $sql = $maker->new
                      ->add_from($class->TABLE)
                      ->add_select('park_id')
                      ->add_where(name => $name);
    } @$names;
    my $sql = intersect(@sql_list)->as_sql;
    my $result = $dbh->selectall_arrayref($sql, undef, @$names);
    [ map { @$_ } @$result ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;
