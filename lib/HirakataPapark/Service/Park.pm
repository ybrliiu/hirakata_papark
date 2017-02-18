package HirakataPapark::Service::Park {

  use Mouse;
  use HirakataPapark;

  use Smart::Args qw( args args_pos );

  with 'HirakataPapark::Service::Service';

  sub get_park_by_id {
    args_pos my $self, my $park_id => 'Num';
    my $park = $self->model('Parks')->new->get_row_by_id($park_id)->get;
    { park => $park };
  }

}

1;

