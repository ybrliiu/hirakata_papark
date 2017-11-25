package Either::Right {

  use v5.14;
  use warnings;
  use parent 'Either::Either';

  use Either::Left;

  sub new {
    my ($class, $content) = @_;
    Carp::croak 'Too few arguments (required: $content)' if @_ < 2;
    bless {content => $content}, $class;
  }

  sub fold {
    my ($self, $left_code, $right_code) = @_;
    Carp::croak 'Too few arguments (required: $left_code, $right_code)' if @_ < 3;
    local $_ = $self->{content};
    $right_code->($self->{content});
  }

  sub is_left() { 0 }

  sub is_right() { 1 }

  sub join_left {
    my $self = shift;
    $self;
  }

  sub join_right {
    my $self = shift;
    $self->{content}->isa('Either::Either') ? $self->{content} : Carp::croak 'cant join_right';
  }

  sub swap {
    my $self = shift;
    Either::Left->new($self->{content});
  }

  sub match {
    Carp::confess 'Invalid arguments' if @_ < 5;
    my ($self, %args) = @_;
    for (qw/ Right Left /) {
      my $code = $args{$_};
      Carp::confess " please specify process $_ " if ref $code ne 'CODE';
    }
    local $_ = $self->{content};
    $args{Right}->( $self->{content} );
  }

}

1;

