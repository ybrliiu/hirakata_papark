package HirakataPapark::Model::Users {

  use Mouse;
  use HirakataPapark;

  use Smart::Args qw( args );
  
  use constant TABLE => 'user';

  with qw( HirakataPapark::Model::Role::DB );

  sub add_row {
    args my $self, my $id => 'Str',
      my $name        => 'Str',
      my $password    => 'Str',
      my $twitter_id  => { isa => 'Str', default => '' },
      my $facebook_id => { isa => 'Str', default => '' },
      my $address     => { isa => 'Str', default => '' },
      my $profile     => { isa => 'Str', default => '' };

    $self->insert({
      name        => $name,
      password    => $password,
      twitter_id  => $twitter_id,
      facebook_id => $facebook_id,
      address     => $address,
      profile     => $profile,
    });
  }

  sub get_row_by_seacret_id($self, $seacret_id) {
    $self->select({seacret_id => $seacret_id})->first_with_option;
  }

  sub get_row_by_id($self, $id) {
    $self->select({id => $id})->first_with_option;
  }

  sub get_row_by_name($self, $name) {
    $self->select({name => $name})->first_with_option;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

