package HirakataPapark::Validator::MessageData {

  use Mouse;
  use HirakataPapark;

  has 'param'    => ( is => 'ro', isa => 'HashRef[Str]', default => sub { +{} } );
  has 'message'  => ( is => 'ro', isa => 'HashRef[Str]', default => sub { +{} } );
  has 'function' => ( is => 'ro', isa => 'HashRef[Str]', default => sub { +{} } );

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

# HirakataPapark::Validator のためのメッセージデータオブジェクト
