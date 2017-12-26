package HirakataPapark::Service::User::LoginFromTwitter {

  use Mouse;
  use HirakataPapark;
  use Either;
  use Option;

  has 'users' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Users::Users',
    required => 1,
  );

  with qw( HirakataPapark::Service::User::Role::UseTwitterAPI );

  # Either[ Option[Str] | Str ]
  sub login($self) {
    my $res = $self->api_caller->account_verify_credentials;
    my $twitter_id = $res->{id};
    $self->users->get_row_by_twitter_id($twitter_id)->match(
      Some => sub ($user) {
        my $session = $self->session;
        $session->set(change_id => 1);
        $session->set('user.seacret_id' => $user->seacret_id);
        right option $session->get('user.originally_seen_page');
      },
      None => sub { left 'No such user' },
    );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

