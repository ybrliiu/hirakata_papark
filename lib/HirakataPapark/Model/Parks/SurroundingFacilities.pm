package HirakataPapark::Model::Parks::SurroundingFacilities {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );

  use constant HANDLE_TABLE_NAME => 'park_surrounding_facility';

  with qw(
    HirakataPapark::Model::Role::DB::RowHandler
    HirakataPapark::Model::Role::DB::RelatedToPark
    HirakataPapark::Model::Role::DB::Parks::SurroundingFacilities
  );

  sub add_row {
    args my $self, my $park_id => 'Int',
      my $name    => 'Str',
      my $comment => { isa => 'Str', default => '' };

    $self->insert({
      park_id => $park_id,
      name    => $name,
      comment => $comment,
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

  sub get_surrounding_facility_list($self) {
    my @facility_list = map { $_->name }
      $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => ['name'] } )->all;
    \@facility_list;
  }

  __PACKAGE__->meta->make_immutable;

}

1;


