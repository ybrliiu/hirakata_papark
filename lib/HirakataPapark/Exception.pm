package HirakataPapark::Exception {

  use Mouse;
  use HirakataPapark;
  extends 'Exception::Tiny';

  has 'line' => ( is => 'ro', isa => 'Int', required => 1 );
  has [qw/ message file package subroutine stack_trace /] =>
    ( is => 'ro', isa => 'Str', required => 1 );
  
  # override
  sub throw {
    my $class = shift;

    my %args;
    if (@_ == 1) {
      $args{message} = shift;
    } else {
      %args = @_;
    }
    $args{message} = $class unless defined $args{message} && $args{message} ne '';

    ($args{package}, $args{file}, $args{line}) = caller(0);
    $args{subroutine}  = (caller(1))[3];
    $args{stack_trace} = $args{message} . Carp::longmess;

    die $class->new(%args);
  }

  override as_string => sub ($self, @) {
    << "EOS";
[@{[ ref $self ]}]

message : @{[ $self->message ]}

stacktrace : @{[ $self->stack_trace ]}

EOS
  };

}

1;

