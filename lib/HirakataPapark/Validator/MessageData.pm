package HirakataPapark::Validator::MessageData {

  use Mouse;
  use HirakataPapark;
  use Option;

  has 'param'    => ( is => 'ro', isa => 'HashRef[Str]', default => sub { +{} } );
  has 'message'  => ( is => 'ro', isa => 'HashRef[Str]', default => sub { +{} } );
  has 'function' => ( is => 'ro', isa => 'HashRef[Str]', default => sub { +{} } );

  sub get_param($self, $key) {
    option $self->param->{$key};
  }

  sub get_message($self, $key) {
    option $self->message->{$key};
  }

  sub get_function($self, $key) {
    option $self->function->{$key};
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

# HirakataPapark::Validator のためのメッセージデータオブジェクト
