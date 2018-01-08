package HirakataPapark::Model::Users::ParkEditHistories::OneToMany::LangRecords {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use Option ();

  my $LangRecord = 
    'HirakataPapark::Model::Users::ParkEditHistories::OneToMany::LangRecord';
  for my $attr_name ( map { "_$_" } HirakataPapark::Types->LANGS->@* ) {
    has $attr_name => (
      is       => 'ro',
      isa      => "Maybe[$LangRecord]",
      lazy     => 1,
      default  => sub { undef },
      init_arg => substr($attr_name, 1),
    );
  }

  for my $attr_name (HirakataPapark::Types->LANGS->@*) {
    __PACKAGE__->meta->add_method($attr_name => sub {
      my $self = shift;
      @_ ? $self->${\"_$attr_name"}(shift) : Option::option($self->${\"_$attr_name"});
    });
  }

  sub has_all($self) {
    my $has_empty = grep {
      !$self->$_->match(
        Some => sub ($lang_record) { $lang_record->has_all },
        None => sub { 0 },
      );
    } HirakataPapark::Types->LANGS->@*;
    !$has_empty;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
