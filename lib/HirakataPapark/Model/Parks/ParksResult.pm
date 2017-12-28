package HirakataPapark::Model::Parks::ParksResult {

  use Mouse;
  use HirakataPapark;
  use Option;

  extends qw( HirakataPapark::Model::Result );

  has 'id_map' => (
    is      => 'ro',
    isa     => 'HashRef[HirakataPapark::DB::Row]',
    lazy    => 1,
    builder => '_build_id_map',
  );

  sub _build_id_map($self) {
    +{ map { $_->id => $_ } $self->contents->@* };
  }

  sub get_by_id($self, $id) {
    option $self->id_map->{$id}
  }

  sub to_json_for_marker($self) {
    "[ " . (join ", ", map { $_->to_json_for_marker } $self->contents->@*) . " ]";
  }

  __PACKAGE__->meta->make_immutable;

}

1;

