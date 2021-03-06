package HirakataPapark::Model::Users::Users {

  use Mouse;
  use HirakataPapark;

  use Smart::Args qw( args );
  
  use constant HANDLE_TABLE_NAME => 'user';

  with 'HirakataPapark::Model::Role::DB::RowHandler';

  sub add_row {
    args my $self, my $id => 'Str',
      my $name          => 'Str',
      my $password      => 'Str',
      my $address       => { isa => 'Str', default => '' },
      my $profile       => { isa => 'Str', default => '' },
      my $twitter_id    => { isa => 'Maybe[Str]', default => undef },
      my $facebook_id   => { isa => 'Maybe[Str]', default => undef },
      my $can_edit_park => { isa => 'Bool', default => 1 };

    $self->insert({
      id            => $id,
      name          => $name,
      password      => $password,
      address       => $address,
      profile       => $profile,
      twitter_id    => $twitter_id,
      facebook_id   => $facebook_id,
      can_edit_park => $can_edit_park,
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

  sub get_row_by_twitter_id($self, $twitter_id) {
    $self->select({twitter_id => $twitter_id})->first_with_option;
  }

  sub get_row_by_facebook_id($self, $facebook_id) {
    $self->select({facebook_id => $facebook_id})->first_with_option;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

