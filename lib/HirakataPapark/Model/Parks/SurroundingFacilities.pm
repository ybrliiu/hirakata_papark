package HirakataPapark::Model::Parks::SurroundingFacilities {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );

  use constant TABLE => 'park_surrounding_facility';

  with 'HirakataPapark::Model::Role::DB::RelatedToPark';

  sub add_row {
    args my $self,
      my $park_id         => 'Int',
      my $name            => 'Str',
      my $english_name    => 'Str',
      my $comment         => { isa => 'Str', default => '' },
      my $english_comment => { isa => 'Str', default => '' };

    $self->insert({
      park_id         => $park_id,
      name            => $name,
      english_name    => $english_name,
      comment         => $comment,
      english_comment => $english_comment,
    });
  }

  sub get_names_by_park_id($self, $park_id) {
    [
      map { $_->name } 
      $self->select(
        { park_id => $park_id },
        { prefix => 'SELECT DISTINCT ', columns => ['name'] },
      )->all
    ];
  }

  sub get_english_names_by_park_id($self, $park_id) {
    [
      map { $_->english_name } 
      $self->select(
        { park_id => $park_id },
        { prefix => 'SELECT DISTINCT ', columns => ['english_name'] },
      )->all
    ];
  }

  sub get_surrounding_facility_list($self) {
    my @facility_list =
      map { $_->name } $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => ['name'] } )->all;
    \@facility_list;
  }

  sub get_english_surrounding_facility_list($self) {
    my @facility_list =
      map { $_->english_name } $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => ['english_name'] } )->all;
    \@facility_list;
  }

  __PACKAGE__->meta->make_immutable;

}

1;


