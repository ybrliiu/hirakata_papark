package HirakataPapark::Model::Multilingual::Parks::LangRecords {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;

  for my $attr_name ( HirakataPapark::Types->LANGS->@* ) {
    has $attr_name => (
      is       => 'ro',
      isa      => 'HirakataPapark::Model::Multilingual::Parks::LangRecord',
      required => 1,
    );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

