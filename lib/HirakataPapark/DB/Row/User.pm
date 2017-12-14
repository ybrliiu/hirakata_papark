package HirakataPapark::DB::Row::User {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::DB::Row';

  sub is_from_site($self) {
    !$self->is_from_twitter && !$self->is_from_facebook;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

