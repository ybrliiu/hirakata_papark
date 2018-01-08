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

    for my $attr_name ( map { "_$_" } $class->COLUMN_NAMES->@* ) {
      $meta->add_attribute($attr_name => {
        is       => 'rw',
        isa      => 'Maybe[Str]',
        lazy     => 1,
        default  => sub { undef },
        init_arg => substr($attr_name, 1),
      });
    }

    for my $attr_name ($class->COLUMN_NAMES->@*) {
      $meta->add_method($attr_name => sub {
        my $self = shift;
        @_ ? $self->${\"_$attr_name"}(shift) : Option::option($self->${\"_$attr_name"});
      });
    }

  }

  has 'prefix' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    builder => 'build_prefix',
  );

  sub build_prefix($self) {
    my $class = ref $self || $self;
    Mojo::Util::decamelize( (split /::/, $class)[-2] ) . '_';
  }

  sub has_all($self) {
    my $has_empty = grep { $self->$_->is_empty } $self->COLUMN_NAMES->@*;
    !$has_empty;
  }

  sub maybe_to_params($self, $history_id) {
    HirakataPapark::Util::for_yield([ map { $self->$_ } $self->COLUMN_NAMES->@* ], sub {
      my %params;
      my @keys = map { $self->prefix . $_ } $self->COLUMN_NAMES->@*;
      @params{@keys} = @_;
      $params{history_id} = $history_id;
      \%params;
    });
  }

}

1;
