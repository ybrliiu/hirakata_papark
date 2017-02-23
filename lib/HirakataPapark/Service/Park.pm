package HirakataPapark::Service::Park {

  use Mouse;
  use HirakataPapark;

  use Smart::Args qw( args args_pos );

  use constant DEFAULT_COMMENT_NUM => 5;

  with 'HirakataPapark::Service::Service';

  sub get_park_by_id {
    args_pos my $self, my $park_id => 'Num';
    my $park = $self->model('Parks')->new->get_row_by_id($park_id)->get;
    { park => $park };
  }

  sub add_comment_by_id {
    args my $self, my $park_id => 'Int', my $name => 'Str', my $message => 'Str';
    $self->model('Parks::Comments')->new->add_row({
      park_id => $park_id,
      name    => $name,
      message => $message,
    });
  }

  sub get_comments_by_id {
    args_pos my $self, my $park_id => 'Int';
    $self->model('Parks::Comments')->new->get_rows_by_park_id({
      park_id => $park_id,
      num     => DEFAULT_COMMENT_NUM,
    });
  }


  __PACKAGE__->meta->make_immutable;

}

1;

