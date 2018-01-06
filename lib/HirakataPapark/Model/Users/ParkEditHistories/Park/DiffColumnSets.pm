package HirakataPapark::Model::Users::ParkEditHistories::Park::DiffColumnSets {

  use Mouse;
  use HirakataPapark;
  use Option;

  use constant DIFF_COLUMNS => [ map { "park_$_" } qw( name address explain ) ];

  for my $attr_name (DIFF_COLUMNS->@*) {

    has $attr_name => (
      is      => 'ro',
      isa     => 'Maybe[Str]',
      default => sub { undef },
    );

    has "maybe_$attr_name" => (
      is       => 'ro',
      # Option::Option[Str]
      isa      => 'Option::Option',
      init_arg => undef,
      default  => sub ($self) { option $self->$attr_name },
    );

  }

  sub get_value($self, $column_name) {
    my $attr_name = "maybe_$column_name";
    $self->can($attr_name) ? $self->$attr_name : none;
  }

  sub has_all($self) {
    my $has_empty = grep { $self->$_->is_empty } 
      map { "maybe_$_" } DIFF_COLUMNS->@*;
    !$has_empty;
  }

  sub to_params($self) {
    +{ map { $_ => $self->$_ } DIFF_COLUMNS->@* };
  }

  __PACKAGE__->meta->make_immutable;

}

1;
