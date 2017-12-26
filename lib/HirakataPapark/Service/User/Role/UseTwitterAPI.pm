package HirakataPapark::Service::User::Role::UseTwitterAPI {

  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Service::User::TwitterAuth::APICaller;

  has 'session' => (
    is       => 'ro',
    isa      => 'Plack::Session',
    required => 1,
  );

  has 'api_caller' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Service::User::TwitterAuth::APICaller',
    lazy    => 1,
    builder => '_build_api_caller',
  );

  sub _build_api_caller($self) {
    HirakataPapark::Service::User::TwitterAuth::APICaller->new(session => $self->session);
  }

}

1;

