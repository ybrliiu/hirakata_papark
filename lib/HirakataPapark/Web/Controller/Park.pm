package HirakataPapark::Web::Controller::Park {

  use Mojo::Base 'HirakataPapark::Web::Controller';
  use HirakataPapark;

  use HirakataPapark::Model::Parks;
  use HirakataPapark::Model::Parks::Plants;
  use HirakataPapark::Model::Parks::Comments;

  use constant DEFAULT_COMMENT_NUM => 5;

  has 'park_id' => sub {
    my $self = shift;
    $self->param('park_id');
  };
  has 'parks'         => sub { HirakataPapark::Model::Parks->new };
  has 'park_plants'   => sub { HirakataPapark::Model::Parks::Plants->new };
  has 'park_comments' => sub { HirakataPapark::Model::Parks::Comments->new };

  sub show_park_by_id {
    my $self = shift;
    $self->parks->get_row_by_id($self->park_id)->match(
      Some => sub {
        my $park = shift;
        $self->stash(park => $park);
        $self->render_to_multiple_lang();
      },
      None => sub { $self->reply_not_found() },
    );
  }

  sub show_park_plants_by_id {
    my $self = shift;
    my $plants = [
      sort { $a->category cmp $b->category }
      $self->park_plants->get_rows_by_park_id($self->park_id)->@*
    ];
    $self->parks->get_row_by_id($self->park_id)->match(
      Some => sub {
        my $park = shift;
        $self->stash({
          park   => $park,
          plants => $plants,
        });
        $self->render_to_multiple_lang();
      },
      None => sub { $self->reply_not_found() },
    );
  }

  sub add_comment_by_id {
    my $self = shift;
    $self->park_comments->add_row({
      park_id => $self->park_id,
      name    => $self->param('name') || '名無し',
      message => $self->param('message'),
    });
    $self->render(text => 'add comment success');
  }

  sub get_comments_by_id {
    my $self = shift;
    my $comments = $self->park_comments
      ->get_rows_by_park_id($self->park_id, DEFAULT_COMMENT_NUM);
    $self->render(comments => $comments);
  }


}

1;

