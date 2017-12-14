package HirakataPapark::Service::User::ShowParkUser {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Service::Role::User';

  has 'park_stars' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Parks::Stars',
    required => 1,
  );

  sub is_park_stared($self, $park_id) {
    $self->park_stars
      ->get_row_by_park_id_and_user_seacret_id($park_id, $self->seacret_id)
      ->is_defined ? 1 : 0;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

