package HirakataPapark::Model::Users::ParkEditHistories::History::Item::ItemImpl {
  
  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Types;
  use Mojo::Util;

  requires qw( COLUMN_NAMES );

  my $LangRecords =
    'HirakataPapark::Model::Users::ParkEditHistories::History::LangRecords';
  has 'lang_records' => (
    is       => 'ro',
    isa      => $LangRecords,
    handles  => [qw( has_all )],
    required => 1,
  );

  has 'prefix' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    builder => 'build_prefix',
  );

  sub build_prefix($self) {
    my $class = ref $self || $self;
    Mojo::Util::decamelize( (split /::/, $class)[-1] ) . '_';
  }

}

1;
