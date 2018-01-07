package HirakataPapark::Model::Users::ParkEditHistories::Equipment::HistoryToAdd::LangRecords {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use Option;

  my $LangRecord =
    'HirakataPapark::Model::Users::ParkEditHistories::Equipment::HistoryToAdd::LangRecord';

  for my $lang (HirakataPapark::Types->LANGS->@*) {

    has $lang => (
      is      => 'ro',
      isa     => "Maybe[$LangRecord]",
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

  with 'HirakataPapark::Model::Users::ParkEditHistories::Equipment::History::LangRecords';

  sub get_lang_record($self, $lang) {
    my $attr_name = "maybe_$lang";
    $self->can($attr_name) ? $self->$attr_name : none;
  }

  sub has_all($self) {
    my $has_empty = grep {
      my $attr_name = "maybe_$_";
      !$self->$attr_name->match(
        Some => sub ($lang_record) { $lang_record->has_all },
        None => sub { 0 },
      );
    } HirakataPapark::Types->LANGS->@*;
    !$has_empty;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
