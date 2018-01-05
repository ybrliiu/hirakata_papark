package HirakataPapark::Model::Users::ParkEditHistories::Park::History::Result {

  use Mouse;
  use HirakataPapark;
  extends qw( HirakataPapark::Model::Users::ParkEditHistories::Park::History );
    
  has 'history_id' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
  );

  __PACKAGE__->meta->make_immutable;

}

1;
