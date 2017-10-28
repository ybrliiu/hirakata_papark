package HirakataPapark::Service::Root {

  use Mouse;
  use HirakataPapark;

  has 'parks' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Model::Parks',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Parks')->new;
    },
  );

  with 'HirakataPapark::Service::Service';

  sub root_ja {
    my $self = shift;
    $self->parks->get_rows_all;
    +{ parks_json => $self->parks->to_json_for_marker };
  }

  sub root_en {
    my $self = shift;
    $self->parks->get_rows_all;
    +{ parks_json => $self->parks->to_english_json_for_marker };
  }

  __PACKAGE__->meta->make_immutable;

}

1;

