package HirakataPapark::Model::Multilingual::Parks::LangRecord {

  use Mouse;
  use HirakataPapark;
  
  use constant COLUMN_NAMES => [qw( name address explain )];

  for my $attr_name ( COLUMN_NAMES->@* ) {
    has $attr_name => (
      is       => 'ro',
      isa      => 'Str',
      required => 1,
    );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

