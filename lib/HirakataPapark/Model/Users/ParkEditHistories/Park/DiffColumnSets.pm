package HirakataPapark::Model::Users::ParkEditHistories::Park::DiffColumnSets {

  use Mouse;
  use HirakataPapark;

  use constant DIFF_COLUMNS => [ map { "park_$_" } qw( name address explain ) ];

  for my $attr_name (DIFF_COLUMNS->@*) {
    has $attr_name => (
      is       => 'ro',
      isa      => 'Str',
      required => 1,
    );
  }

  sub to_params($self) {
    +{ map { $_ => $self->$_ } DIFF_COLUMNS->@* };
  }

  __PACKAGE__->meta->make_immutable;

}

1;
