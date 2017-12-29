package HirakataPapark::Model::Result {

  use Mouse;
  use HirakataPapark;
  use Option;

  use overload (
    '@{}'      => sub { $_[0]->contents },
    'bool'     => sub { 1 },
    'fallback' => 1,
  );

  has 'contents' => ( is => 'ro', isa => 'ArrayRef', required => 1 );

  sub len($self) { $#{ $self->contents } + 1 }

  sub get($self, $index) { option $self->contents->[$index] }

  sub get_all($self) { $self->contents }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

Modelから複数のデータを返却する時に使う型

