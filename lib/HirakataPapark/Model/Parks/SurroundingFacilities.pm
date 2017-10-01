package HirakataPapark::Model::Parks::SurroundingFacilities {

  use Mouse;
  use HirakataPapark;

  use Set::Object;
  use Smart::Args qw( args args_pos );

  use constant TABLE => 'park_surrounding_facility';

  with 'HirakataPapark::Model::Role::DB';

  sub add_row {
    args my $self,
      my $park_id => 'Int',
      my $name    => 'Str',
      my $comment => { isa => 'Int', default => '' };
    $self->insert({
      park_id => $park_id,
      name    => $name,
      comment => $comment,
    });
  }

  sub get_rows_by_name {
    args_pos my $self, my $name => 'Str';
    [ $self->select({name => $name})->all ];
  }

  sub get_rows_by_names_with_prefetch {
    args_pos my $self, my $names => 'ArrayRef[Str]';
    my @ary = map { ('=', $_) } @$names;
    [ $self->select( { name => \@ary }, { prefetch => ['park'] } )->all ];
  }

  sub get_facility_list {
    my $self = shift;
    my @facility_list =
      map { $_->name } $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => ['name'] } )->all;
    \@facility_list;
  }

  __PACKAGE__->meta->make_immutable;

}

1;


