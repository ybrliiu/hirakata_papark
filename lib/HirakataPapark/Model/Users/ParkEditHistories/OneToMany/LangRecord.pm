package HirakataPapark::Model::Users::ParkEditHistories::OneToMany::LangRecord {
  
  use Mouse::Role;
  use HirakataPapark;
  use Option;
  use Mojo::Util;
  use HirakataPapark::Util;

  # constant
  requires qw( COLUMN_NAMES );

  sub add_attributes($class) {
    my $meta = $class->meta;

    for my $attr_name ($class->COLUMN_NAMES->@*) {
      $meta->add_attribute($attr_name => {
        is       => 'rw',
        isa      => 'Option::Option',
        lazy     => 1,
        builder  => "_build_$attr_name",
        init_arg => undef,
      });
      $meta->add_method("_build_$attr_name" => sub ($self) {
        Option::option( $self->${\"_$attr_name"} );
      });
    }

    for my $attr_name ( map { "_$_" } $class->COLUMN_NAMES->@* ) {
      $meta->add_attribute($attr_name => {
        is       => 'ro',
        isa      => 'Maybe[Str]',
        lazy     => 1,
        default  => sub { undef },
        init_arg => substr($attr_name, 1),
      });
    }

  }

  has 'prefix' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    builder => '_build_prefix',
  );

  sub _build_prefix($self) {
    Mojo::Util::decamelize( (split /::/, ref $self)[-2] );
  }

  sub has_all($self) {
    my $has_empty = grep { $self->$_->is_empty } $self->COLUMN_NAMES->@*;
    !$has_empty;
  }

  sub maybe_to_params($self, $history_id) {
    HirakataPapark::Util::for_yield([ map { $self->$_ } $self->COLUMN_NAMES->@* ], sub {
      my %params;
      my @keys = map { "@{[ $self->prefix ]}_$_" } $self->COLUMN_NAMES->@*;
      @params{@keys} = @_;
      $params{history_id} = $history_id;
      \%params;
    });
  }

}

1;
