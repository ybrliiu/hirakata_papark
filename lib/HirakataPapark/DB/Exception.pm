package HirakataPapark::DB::Exception {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::Exception';

  has 'sql'    => ( is => 'ro', isa => 'Str', required => 1 );
  has 'bind'   => ( is => 'ro', isa => 'Str', required => 1 );

  override as_string => sub ($self, @) {
    << "EOS";
[@{[ ref $self ]}]

Stacktrace : @{[ $self->stack_trace ]}

Reason : @{[ $self->message ]}

SQL: @{[ $self->sql ]}

BIND: @{[ $self->bind ]}

EOS
  };

  __PACKAGE__->meta->make_immutable;

}

1;

