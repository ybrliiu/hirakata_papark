package HirakataPapark::Service::User::MyPage::User {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Service::Role::User';

  has 'parks' => (
    is       => 'ro',
    does     => 'HirakataPapark::Model::Role::DB::Parks::Parks',
    required => 1,
  );

  sub favorite_parks($self) {
    $self->parks->get_stared_rows_by_user_seacret_id($self->seacret_id);
  }

  __PACKAGE__->meta->make_immutable;

}

1;

