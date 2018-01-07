package HirakataPapark::Model::Users::ParkEditHistories::Equipment::HistoryToAdd::LangRecord {
  
  use Mouse;
  use HirakataPapark;
  use Option;
  use HirakataPapark::Util qw( for_yield );
  use HirakataPapark::Model::Users::ParkEditHistories::Equipment::History::LangRecord;
  
  my $columns
    = HirakataPapark::Model::Users::ParkEditHistories::Equipment::History::LangRecord::COLUMNS;

  sub ATTR_NAMES { [ map { "maybe_$_" } @$columns ] }

  for my $attr_name (@$columns) {

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

  with 'HirakataPapark::Model::Users::ParkEditHistories::Equipment::History::LangRecord';

  sub get_value($self, $column_name) {
    my $attr_name = "maybe_$column_name";
    $self->can($attr_name) ? $self->$attr_name : none;
  }

  sub has_all($self) {
    my $has_empty = grep { $self->$_->is_empty } ATTR_NAMES()->@*;
    !$has_empty;
  }

  sub maybe_to_params($self, $history_id) {
    for_yield [ map { $self->$_ } $self->ATTR_NAMES->@* ], sub {
      my %params;
      @params{$self->COLUMNS->@*} = @_;
      $params{history_id} = $history_id;
      \%params;
    };
  }

  __PACKAGE__->meta->make_immutable;

}

1;
