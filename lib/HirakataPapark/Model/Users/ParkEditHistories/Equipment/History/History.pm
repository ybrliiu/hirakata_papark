package HirakataPapark::Model::Users::ParkEditHistories::Equipment::History::History {

  use Mouse::Role;
  use HirakataPapark;

  has 'park_id' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
  );

  has 'editer_seacret_id' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
  );

  has 'edited_time' => (
    is      => 'ro',
    isa     => 'Int',
    default => sub { time },
  );

  my $Equipment =
    'HirakataPapark::Model::Users::ParkEditHistories::Equipment::History::Equipment';
  has 'equipments' => (
    is       => 'ro',
    isa      => "ArrayRef[$Equipment]",
    required => 1,
  );

  sub has_all($self) {
    my $has_empty = grep { !$_->has_all } $self->equipments->@*;
    !$has_empty;
  }

  sub equipments_map($self, $code) {
    my @values = map { $code->($_) } $self->equipments->@*;
    \@values;
  }

}

1;
