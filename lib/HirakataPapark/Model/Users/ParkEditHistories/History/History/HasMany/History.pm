package HirakataPapark::Model::Users::ParkEditHistories::History::History::HasMany::History {

  use Mouse::Role;
  use HirakataPapark;

  my $Item =
    'HirakataPapark::Model::Users::ParkEditHistories::History::Item::Item';
  has 'items' => (
    is       => 'ro',
    does     => "ArrayRef[$Item]",
    required => 1,
  );

  with 'HirakataPapark::Model::Users::ParkEditHistories::History::History::History';

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
