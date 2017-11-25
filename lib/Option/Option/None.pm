package Option::None {

  use v5.14;
  use warnings;
  use parent 'Option::Option';
  
  use Either::Right;
  use Either::Left;
  use Option::NoSuchElementException;

  # override
  sub new {
    my $class = shift;
    bless +{}, $class;
  }

  # override
  sub exists {
    my ($self, $code) = @_;
    Carp::croak 'Too few arguments (required : $code)' if @_ < 2;
    ();
  }

  # override
  sub fold {
    my ($self, $for_none) = @_;
    Carp::croak 'Too few arguments (required : $for_none)' if @_ < 2;
    sub {
      Carp::croak 'Too few arguments (required : $for_some)' if @_ < 1;
      my $for_some = shift;
      $for_none->();
    };
  }

  # override
  sub flatten {
    my $self = shift;
    $self;
  }

  # override
  sub get {
    Option::NoSuchElementException->throw;
  }

  # override
  sub get_or_else {
    my ($self, $default) = @_;
    Carp::croak 'Too few arguments (required: $default)' if @_ < 2;
    $default;
  }

  # override
  sub is_defined { 0 }

  # override
  sub map {
    my ($self, $code) = @_;
    Carp::croak 'Too few arguments (required: $code)' if @_ < 2;
    $self;
  }

  # override
  sub match {
    my ($self, %args) = @_;
    Carp::croak 'Invalid arguments' if @_ < 5;
    for (qw/ Some None /) {
      my $code = $args{$_};
      Carp::croak "Please specify process of $_ " if ref $code ne 'CODE';
    }
    $args{None}->();
  }

  # override
  sub to_left {
    my ($self, $default) = @_;
    Carp::croak 'Too few arguments (required: $default)' if @_ < 2;
    Either::Right->new($default);
  }

  # override
  sub to_list { () }

  # override
  sub to_right {
    my ($self, $default) = @_;
    Carp::croak 'Too few arguments (required: $default)' if @_ < 2;
    Either::Left->new($default);
  }

  # override
  sub yield {
    my ($self, $code) = @_;
    Carp::croak 'Too few arguments (required: $code)' if @_ < 2;
    ();
  }

}

1;
