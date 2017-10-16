package HirakataPapark::Model::Parks::Equipments {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );

  use constant TABLE => 'park_equipment';

  with 'HirakataPapark::Model::Role::DB::RelatedToPark';

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

  sub get_equipment_list($self) {
    my @tag_list =
      map { $_->name } $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => ['name'] } )->all;
    \@tag_list;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
