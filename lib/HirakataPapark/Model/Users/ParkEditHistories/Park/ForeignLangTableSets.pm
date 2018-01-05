package HirakataPapark::Model::Users::ParkEditHistories::Park::ForeignLangTableSets {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use Option;

  my $DIFF_COLUMN_SETS =
    'HirakataPapark::Model::Users::ParkEditHistories::Park::DiffColumnSets';

  for my $lang (HirakataPapark::Types->LANGS->@*) {

    has $lang => (
      is      => 'ro',
      isa     => "Maybe[$DIFF_COLUMN_SETS]",
      default => sub { undef },
    );

    has "maybe_$lang" => (
      is       => 'ro',
      # Option::Option[DiffColumnSets]
      isa      => 'Option::Option',
      init_arg => undef,
      lazy     => 1,
      default  => sub ($self) { option $self->$lang },
    );

  }

  sub get_sets($self, $lang) {
    my $attr_name = "maybe_$lang";
    $self->can($attr_name) ? $self->$attr_name : none;
  }

  sub has_all($self) {
    my $has_empty = grep { $self->$_->is_empty } 
      map { "maybe_$_" } HirakataPapark::Types->LANGS->@*;
    !$has_empty;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
