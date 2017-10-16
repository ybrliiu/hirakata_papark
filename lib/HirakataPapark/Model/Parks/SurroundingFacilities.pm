package HirakataPapark::Model::Parks::SurroundingFacilities {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );

  use constant TABLE => 'park_surrounding_facility';

  with 'HirakataPapark::Model::Role::DB::RelatedToPark';

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

  sub get_surrounding_facility_list($self) {
    my @facility_list =
      map { $_->name } $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => ['name'] } )->all;
    \@facility_list;
  }

  __PACKAGE__->meta->make_immutable;

}

1;


