package HirakataPapark::Model::Users::ParkEditHistories::OneToMany::Item::ItemImpl {
  
  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Types;
  use Mojo::Util;

  requires qw( COLUMN_NAMES );

  my $LangRecords =
    'HirakataPapark::Model::Users::ParkEditHistories::OneToMany::LangRecords';
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
    builder => '_build_prefix',
  );

  sub _build_prefix($self) {
    Mojo::Util::decamelize( (split /::/, ref $self)[-1] );
  }

}

1;
