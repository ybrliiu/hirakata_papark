package HirakataPapark::Web::Controller::Park {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use HirakataPapark::Service::Park;

  has 'service' => sub { HirakataPapark::Service::Park->new };

  sub show_park_by_id {
    my $self = shift;
    my $result = $self->service->get_park_by_id( $self->param('park_id') );
    $self->stash($result);
    $self->render;
  }

  sub add_comment_by_id {
    my $self = shift;
    my $result = $self->service->add_comment_by_id({
      park_id => $self->param('park_id'),
      name    => $self->param('name') || '名無し',
      message => $self->param('message') =~ s/(\n|\r\n|\r)/<br>/gr,
    });
    $self->render(text => $result);
  }

}

1;

