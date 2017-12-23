package HirakataPapark::Validator::Params {

  use Mouse;
  use HirakataPapark;
  use Option;

  has 'data' => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
  );

  around BUILDARGS => sub ($orig, $self, @args) {
    if (ref $args[0] eq 'HASH') {
      $self->$orig(data => shift @args);
    } else {
      $self->$orig(@args);
    }
  };

  sub param($self, $key) {
    option $self->data->{$key};
  }

  sub set($self, $key, $value) {
    $self->data->{$key} = $value;
  }

  sub to_hash($self) { $self->data }

  __PACKAGE__->meta->make_immutable;

}

1;

