package HirakataPapark::Model::Users::ParkEditHistories::OneToMany::History::History {

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

  my $Item =
    'HirakataPapark::Model::Users::ParkEditHistories::OneToMany::Item::Item';
  has 'items' => (
    is       => 'ro',
    does     => "ArrayRef[$Item]",
    required => 1,
  );

  sub has_all($self) {
    my $has_empty = grep { !$_->has_all } $self->items->@*;
    !$has_empty;
  }

  sub items_map($self, $code) {
    my @values = map { $code->($_) } $self->items->@*;
    \@values;
  }

}

1;
