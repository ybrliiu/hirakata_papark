package HirakataPapark::Service::User::User {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::DB::Schema;

  {
    # table カラムは全て委譲
    my @fields = HirakataPapark::DB::Schema->context->schema->get_table('user')->get_fields();

    has 'row' => (
      is       => 'ro',
      isa      => 'HirakataPapark::DB::Row',
      handles  => \@fields,
      required => 1,
    );
  }

  has 'park_stars' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Parks::Stars',
    required => 1,
  );

  sub is_park_stared($self, $park_id) {
    $self->park_stars
      ->get_row_by_park_id_and_user_seacret_id($park_id, $self->seacret_id)
      ->is_defined ? 1 : 0;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

