package HirakataPapark::Model::Multilingual::Parks::MultilingualRow {

  use Mouse;
  use HirakataPapark;
  use aliased 'HirakataPapark::Model::Multilingual::Parks::LangRecord';

  has 'lang' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Types::Lang',
    required => 1,
  );

  has 'zipcode' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  for my $name (qw/ x y area /) {
    has $name => (
      is       => 'ro',
      isa      => 'Num',
      required => 1,
    );
  }

  has 'is_evacuation_area' => (
    is       => 'ro',
    isa      => 'Bool',
    required => 1,
  );

  has 'lang_records' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Multilingual::Parks::LangRecords',
    required => 1,
  );

  my $meta = __PACKAGE__->meta;

  for my $method_name ( LangRecord->COLUMN_NAMES->@* ) {
    $meta->add_method($method_name => sub ($self) {
      $self->lang_records->${\$self->lang}->$method_name;
    });
  }

  $meta->make_immutable;

}

1;

