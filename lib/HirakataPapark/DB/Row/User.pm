package HirakataPapark::DB::Row::User {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::DB::Row';

  has 'name' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub ($self) { $self->get_column('user_name') },
  );

  __PACKAGE__->meta->make_immutable;

}

1;

