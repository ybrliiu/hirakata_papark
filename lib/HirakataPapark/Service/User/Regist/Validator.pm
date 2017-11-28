package HirakataPapark::Service::User::Regist::Validator {

  use Mouse;
  use HirakataPapark;
  use Either;

  use constant {
    MIN_NAME_LEN     => 1,
    MAX_NAME_LEN     => 20,
    MIN_ID_LEN       => 4,
    MAX_ID_LEN       => 14,
    MIN_PASSWORD_LEN => 10,
    MAX_PASSWORD_LEN => 40,
    MAX_ADDRESS_LEN  => 40,
    MAX_PROFILE_LEN  => 400,
  };

  has 'name'        => ( is => 'ro', isa => 'Str', required => 1 );
  has 'id'          => ( is => 'ro', isa => 'Str', required => 1 );
  has 'twitter_id'  => ( is => 'ro', isa => 'Str', default => '' );
  has 'facebook_id' => ( is => 'ro', isa => 'Str', default => '' );
  has 'address'     => ( is => 'ro', isa => 'Str', default => '' );
  has 'profile'     => ( is => 'ro', isa => 'Str', default => '' );

  has 'validator' => ( is => 'ro', isa => 'FormValidator::Lite', required => 1 );

  sub _build_validator($self) {
  }

  sub validate($self) {
  }

  __PACKAGE__->meta->make_immutable;

}

1;

