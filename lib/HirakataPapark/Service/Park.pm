package HirakataPapark::Service::Park {

  use Mouse;
  use HirakataPapark;

  use Smart::Args qw( args );

  use constant DEFAULT_COMMENT_NUM => 5;

  has 'parks' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Parks',
    lazy    => 1,
    default => sub ($self) { $self->model('Parks')->new },
  );

  has 'park_plants' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Parks::Plants',
    lazy    => 1,
    default => sub ($self) { $self->model('Parks::Plants')->new },
  );

  has 'park_comments' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Parks::Comments',
    lazy    => 1,
    default => sub ($self) { $self->model('Parks::Comments')->new },
  );

  with 'HirakataPapark::Service::Service';

  sub get_park_by_id($self, $park_id) {
    my $park = $self->parks->get_row_by_id($park_id)->get;
    { park => $park };
  }

  sub get_park_plants_by_id($self, $park_id) {
    my $plants = [
      sort { $a->category cmp $b->category }
      $self->park_plants->get_rows_by_park_id($park_id)->@*
    ];
    my $park = $self->parks->get_row_by_id($park_id)->get;
    {
      park   => $park,
      plants => $plants,
    };
  }

  sub add_comment_by_id {
    args my $self, my $park_id => 'Int', my $name => 'Str', my $message => 'Str';
    $self->park_comments->add_row({
      park_id => $park_id,
      name    => $name,
      message => $message,
    });
  }

  sub get_comments_by_id($self, $park_id) {
    $self->park_comments->new->get_rows_by_park_id({
      park_id => $park_id,
      num     => DEFAULT_COMMENT_NUM,
    });
  }


  __PACKAGE__->meta->make_immutable;

}

1;

