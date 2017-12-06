package HirakataPapark::Model::Parks::Stars {

  use Mouse;
  use HirakataPapark;

  use Smart::Args qw( args );

  use constant TABLE => 'park_star';

  with 'HirakataPapark::Model::Role::DB';

  sub add_row {
    args my $self, my $park_id => 'Int', my $user_seacret_id => 'Int';
    $self->insert({
      park_id         => $park_id,
      user_seacret_id => $user_seacret_id,
    });
  }

  sub get_rows_by_park_id($self, $park_id) {
    $self->result_class->new([ $self->select({ park_id => $park_id })->all ]);
  }
  
  sub get_rows_by_user_seacret_id($self, $user_seacret_id) {
    $self->result_class->new([ $self->select({ user_seacret_id => $user_seacret_id })->all ]);
  }

  sub get_row_by_park_id_and_user_seacret_id($self, $park_id, $user_seacret_id) {
    $self->select({
      user_seacret_id => $user_seacret_id,
      park_id         => $park_id,
    })->first_with_option;
  }
  
  __PACKAGE__->meta->make_immutable;

}

1;

