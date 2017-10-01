package HirakataPapark::Model::Parks::Plants {

  use Mouse;
  use HirakataPapark;

  use Set::Object;
  use Smart::Args qw( args args_pos );

  use constant TABLE => 'park_plants';

  with 'HirakataPapark::Model::Role::DB';

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

  sub get_rows_by_category {
    args_pos my $self, my $category => 'Str';
    [ $self->select({category => $category})->all ];
  }

  sub get_rows_by_categorys {
    args_pos my $self, my $categorys => 'ArrayRef[Str]';
    my @ary = map { ('=', $_) } @$categorys;
    [ $self->select({ category => \@ary })->all ];
  }

  sub get_category_list {
    my $self = shift;
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

  sub get_plants_list {
    my $self = shift;
    my @plants_list =
      map { $_->name } $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => ['name'] } )->all;
    \@plants_list;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

