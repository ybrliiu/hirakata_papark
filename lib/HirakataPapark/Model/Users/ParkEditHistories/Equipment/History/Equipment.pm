package HirakataPapark::Model::Users::ParkEditHistories::Equipment::History::Equipment {
  
  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Types;

  my $LangRecords =
    'HirakataPapark::Model::Users::ParkEditHistories::Equipment::History::LangRecords';

  has 'recommended_age' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
  );

  has 'num' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
  );

  has 'lang_records' => (
    is       => 'ro',
    does     => $LangRecords,
    handles  => [qw( has_all )],
    required => 1,
  );

  my $meta = __PACKAGE__->meta;
  for my $column_name (qw( name comment )) {
    $meta->add_method($column_name => sub ($self) {
      $self->lang_records
        ->get_lang_record($self->lang)->get
        ->get_value($column_name)->get
    })
  }

}

1;
