package HirakataPapark::Model::Users::Users {

  use Mouse;
  use HirakataPapark;

  use Smart::Args qw( args );
  
  use constant TABLE => 'user';

  with qw( HirakataPapark::Model::Role::DB );

  sub add_row {
    args my $self, my $id => 'Str',
      my $name     => 'Str',
      my $password => 'Str',
      my $address  => { isa => 'Str', default => '' },
      my $profile  => { isa => 'Str', default => '' };

    $self->insert({
      id        => $id,
      user_name => $name,
      password  => $password,
      address   => $address,
      profile   => $profile,
    });
  }

  sub get_row_by_seacret_id($self, $seacret_id) {
    $self->select({seacret_id => $seacret_id})->first_with_option;
  }

  sub get_row_by_id($self, $id) {
    $self->select({id => $id})->first_with_option;
  }

  sub get_row_by_name($self, $name) {
    $self->select({user_name => $name})->first_with_option;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

