package HirakataPapark::Model::Parks::Plants {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );

  use constant HANDLE_TABLE_NAME => 'park_plants';

  with qw(
    HirakataPapark::Model::Role::DB::RowHandler
    HirakataPapark::Model::Role::DB::RelatedToPark
    HirakataPapark::Model::Role::DB::Parks::Plants
  );

  sub add_row {
    args my $self, my $park_id => 'Int',
      my $name     => 'Str',
      my $category => 'Str',
      my $comment  => { isa => 'Str', default => '' },
      my $num      => { isa => 'Int', default => 0 };

    $self->insert({
      park_id  => $park_id,
      name     => $name,
      category => $category,
      num      => $num,
      comment  => $comment,
    });
  }

  sub get_all_distinct_rows($self, $columns) {
    $self->create_result(
      $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => $columns } )->rows );
  }

  sub get_categories($self) {
    my @category_list = map { $_->category }
      $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => ['category'] } )->all;
    \@category_list;
  }

  sub get_categories_by_park_id($self, $park_id) {
    my @category_list = map { $_->category } $self->select(
      { park_id => $park_id },
      { prefix => 'SELECT DISTINCT ', columns => ['category'] }
    )->all;
    \@category_list;
  }

  sub get_plants_list($self) {
    my @plants_list = map { $_->name }
      $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => ['name'] } )->all;
    \@plants_list;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

