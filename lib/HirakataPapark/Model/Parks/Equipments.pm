package HirakataPapark::Model::Parks::Equipments {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );

  use constant HANDLE_TABLE_NAME => 'park_equipment';

  with qw(
    HirakataPapark::Model::Role::DB::RowHandler
    HirakataPapark::Model::Role::DB::RelatedToPark
    HirakataPapark::Model::Role::DB::Parks::Equipments
  );

  sub add_row {
    args my $self,
      my $park_id         => 'Int',
      my $name            => 'Str',
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
    my @equipment_list = map { $_->name }
      $self->select( {}, { prefix => 'SELECT DISTINCT ', columns => ['name'] } )->all;
    \@equipment_list;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
