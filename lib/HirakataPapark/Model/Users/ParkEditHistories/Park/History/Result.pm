package HirakataPapark::Model::Users::ParkEditHistories::Park::History::Result {

  use Mouse;
  use HirakataPapark;
  extends qw( HirakataPapark::Model::Users::ParkEditHistories::Park::History );
    
  has 'id' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
  );

  sub BUILD($self, $args) {
    HirakataPapark::Exception->throw('History dont has all lang data.')
      unless $self->has_all;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
