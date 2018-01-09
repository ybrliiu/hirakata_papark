package HirakataPapark::Model::Users::ParkEditHistories::History::History::History {

  use Mouse::Role;
  use HirakataPapark;

  use constant COLUMN_NAMES => [qw( park_id editer_seacret_id edited_time )];

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

}

1;
