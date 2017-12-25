package HirakataPapark::DB::Row::User {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::DB::Row';

  sub is_from_twitter($self) {
    $self->twitter_id;
  }

  sub is_from_facebook($self) {
    $self->facebook_id;
  }

  sub is_from_site($self) {
    !$self->twitter_id && !$self->facebook_id;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

