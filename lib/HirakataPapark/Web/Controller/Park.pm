package HirakataPapark::Web::Controller::Park {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;
  use HirakataPapark::Service::Park;

  has 'service' => sub { HirakataPapark::Service::Park->new };

  sub show_park_by_id {
    my $self = shift;
    my $result = $self->service->get_park_by_id( $self->param('park_id') );
    $self->stash($result);
    $self->render_to_multiple_lang();
  }

  sub show_park_plants_by_id {
    my $self = shift;
    my $result = $self->service->get_park_plants_by_id( $self->param('park_id') );
    $self->stash($result);
    $self->render_to_multiple_lang();
  }

  sub add_comment_by_id {
    my $self = shift;
    $self->service->add_comment_by_id({
      park_id => $self->param('park_id'),
      name    => $self->param('name') || '名無し',
      message => $self->param('message'),
    });
    $self->render(text => 'add comment success');
  }

  sub get_comments_by_id {
    my $self = shift;
    my $comments = $self->service->get_comments_by_id( $self->param('park_id') );
    $self->render(comments => $comments);
  }


}

1;

